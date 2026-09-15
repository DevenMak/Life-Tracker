//
//  PlayerView.swift
//  Life Tracker
//
//  Created by Deven Mak on 2/20/26.
//

import SwiftUI
import CoreData



class CoreDataManager {
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "LifeTrackerContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
        
        context = container.viewContext
    }
    
    
    
    func save() {
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        DispatchQueue.main.async {
            do {
                try self.context.save()
            } catch let error {
                print("Error saving Core Data: \(error)")
            }
        }
    }
}

class ValueViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    public static var shared = ValueViewModel()
    @Published var game: Game?
    @Published var values: [Value] = []
    private var animating: Bool = false
    
    func setUp(game: Game) {
        self.game = game
        if InitialGameSettings.shared.newGame {
            self.values = []
            self.game!.value1 = InitialGameSettings.shared.commander ? "Commander" : ""
            self.game!.value2 = ""
            self.game!.show1 = false
            self.game!.show2 = false
            
        }
        ValueCoordinator.setup()
        save()
    }
    
    func fetchValues() {
        let request = NSFetchRequest<Value>(entityName: "Value")
        do {
            self.values = try self.manager.context.fetch(request)
            if let gameValues = self.game?.values?.allObjects as? [Value] {
                self.values = gameValues
            }
        } catch {}
    }
    
    func fetchPlayerValues(_ player: Player) -> [Value] {
        if let playerValues = player.values?.allObjects as? [Value] {
            return playerValues
        }
        return []
    }
    
    func addValue(_ player: Player, _ name: String, _ count: Int, _ iconName: String, _ rgb: (Double, Double, Double)) {
        
        let value = Value(context: manager.context)
        value.player = player
        value.game = game
        value.name = name
        value.count = Int16(count)
        value.show = false
        value.iconName = iconName
        value.red = rgb.0
        value.green = rgb.1
        value.blue = rgb.2
        save()
    }
    
    func addValueToPlayers(_ name: String, _ count: Int, _ iconName: String, _ rgb: (Double, Double, Double)) {
        for player in PlayerViewModel.shared.players {
            addValue(player, name, count, iconName, rgb)
        }
    }
    
    func increaseValue(_ value: Value) {
        if value.count >= 99 { return }
        value.count+=1
        save()
    }
    func decreaseValue(_ value: Value) {
        if value.count <= 0 { return }
        value.count-=1
        save()
    }
    
    func deleteValue(_ value: Value) {
        manager.context.delete(value)
        save()
    }
    
    func deleteValueFromGame(_ valueName: String) {
        for value in values {
            if value.name == valueName {
                deleteValue(value)
            }
        }
        save()
    }
    
    
    func selectValue(name: String, count: Int, iconName: String, rgb: (Double, Double, Double), custom: Bool) {
        let valueIsInGame = game!.value1 == name || game!.value2 == name
        let valueName = custom && valueIsInGame ? "\(name) (1)" : name

        if !animating {
            if !valueIsInGame || custom {
                if game!.value1 == "" && !game!.commander {
                    game!.value1 = valueName
                    withAnimation(.easeIn(duration: 0.4)) {
                        ValueCoordinator.shared.show1 = true
                    }
                } else if game!.value2 == "" {
                    game!.value2 = valueName
                    withAnimation(.easeIn(duration: 0.4)) {
                        ValueCoordinator.shared.show2 = true
                    }
                } else {
                    self.deleteValueFromGame(self.game!.value2!)
                    self.game!.value2 = valueName
                    
                    
                }
                print("adding value to game")
                addValueToPlayers(valueName, count, iconName, rgb)
                
                
            } else {
                var slotToBeRemoved = 0
                animating = true
                withAnimation(.easeIn(duration: 0.4)) {
                    if game!.value1 == valueName {
                        slotToBeRemoved = 1
                        ValueCoordinator.shared.show1 = false
                    } else {
                        slotToBeRemoved = 2
                        ValueCoordinator.shared.show2 = false
                    }
                    print("starting animation")
                } completion: {
                    if slotToBeRemoved == 1 {
                        print("starting delete")
                        self.deleteValueFromGame(valueName)
                        self.game!.value1 = ""
                    } else if slotToBeRemoved == 2{
                        print("starting delete")
                        self.deleteValueFromGame(valueName)
                        self.game!.value2 = ""
                    }
                    self.animating = false
                }
            }
        }
        print("\(game!.value1!), \(game!.value2!)")

    }
    
    func changeIconName(_ value: Value, _ iconName: String) {
        value.iconName = iconName
        save()
    }
    
    @ViewBuilder
    func getIcon(_ iconName: String) -> some View {
        if let uiImage = UIImage(named: iconName) {
            Image(uiImage: uiImage).iconStyle()
        }
    }
    
    func save() {
        manager.save()
        DispatchQueue.main.async {
            self.fetchValues()
        }
    }
    
}

struct PlayerView: View {
    
    @ObservedObject var player: Player
    @State var show = false
    @ObservedObject var valueVM = ValueViewModel.shared
    @ObservedObject var playerVM = PlayerViewModel.shared
    @StateObject var coordinator = ValueCoordinator.shared
    @State var showSlot1 = false
    var playerValues: [Value] {
        ValueViewModel.shared.fetchPlayerValues(player)
    }
    
       
    var body: some View {
        ZStack {
            UnevenRoundedRectangle(10, 0, 0, 10)
                .fill(.white)
            GeometryReader { geo in
                ZStack {
                    VStack(spacing: 0) {
                        Button(action: {
                            PlayerViewModel.shared.addLife(player)
                        }) {
                            UnevenRoundedRectangle(10,0,0,10)
                                .fill(Color(player.color ?? "Player1"))
                        }
                        Button(action: {
                            PlayerViewModel.shared.loseLife(player)
                        }) {
                            Rectangle()
                                .fill(Color(player.color ?? "Player1"))
                        }
                    }
                    VStack(spacing: 0) {
                        Text("\(player.life)")
                            .boldNumberStyle()
                        Image("heartIcon")
                            .iconStyle()
                    }
                    .allowsHitTesting(false)
                    .foregroundStyle(.white)
                    
                    let x = geo.size.width
                    let y = geo.size.height
                    let commanderY = max(x*frameMult*0.5, min(y, counterHeightLimit*(CGFloat(playerVM.players.count-1))+titleHeight))
                    
                    if coordinator.show1 && !valueVM.game!.commander {
                        CounterView(size: geo.size, player: player, slot: 1)
                            .transition(
                                ZoomTransition(size: geo.size, x: 0, y: y)
                            )
                            .contentShape(
                                UnevenRoundedRectangle(0,0,0,x/15)
                                    .size(width: x*frameMult*0.5, height: x*frameMult*0.5)
                                    .offset(x: x*frameMult*0.5)
                            )
                            .position(x: 0, y: y)
                            
                            .zIndex(100)
                            
                            
                    } else if valueVM.game!.commander {
                        CommanderCounterStack(size: geo.size, player: player)
                            .position(x: x*frameMult*0.25, y: y-commanderY*0.5)
                            .zIndex(100)
                            
                    }
                    if coordinator.show2 {
                        
                        CounterView(size: geo.size, player: player, slot: 2)
                            .transition(
                                ZoomTransition(size: geo.size, x: x, y: y)
                            )
                            .contentShape(
                                UnevenRoundedRectangle(x/15,0,0,0)
                                    .size(width: x*frameMult*0.5, height: x*frameMult*0.5)
                            )
                            .position(x: x, y: y)
                            .zIndex(100)
                            
                    }
                }
            }
        }

    }
}

#Preview {
    TwoPlayerGame()
}
