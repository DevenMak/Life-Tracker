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
    
    func setUp(game: Game) {
        self.game = game
        if InitialGameSettings.shared.newGame {
            self.values = []
            self.game!.value1 = ""
            self.game!.value2 = ""
        }
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
        value.count+=1
        save()
    }
    func decreaseValue(_ value: Value) {
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
        let valueName = name
        let valueIsInGame = game!.value1 == valueName || game!.value2 == valueName
        if !valueIsInGame {
            withAnimation(.easeIn(duration: 0.25)) {
                if game!.value1 == "" {
                    game!.value1 = valueName
                    ValueCoordinator.shared.show1 = true
                } else if game!.value2 == "" {
                    game!.value2 = valueName
                    ValueCoordinator.shared.show2 = true
                } else {
                    game!.value2 = valueName
                    //AnimationCoordinator.shared.animateOut = valueName
                }
            } completion: {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.deleteValueFromGame(valueName)
                }
                self.addValueToPlayers(name, count, iconName, rgb)
            }

        } else {
            withAnimation(.easeIn(duration: 0.25)) {
                if game!.value1 == valueName {
                    game!.value1 = ""
                    ValueCoordinator.shared.show1 = false
                } else {
                    game!.value2 = ""
                    ValueCoordinator.shared.show2 = false
                }
            } completion: {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.deleteValueFromGame(valueName)
                }
            }
            //AnimationCoordinator.shared.animateOut = valueName
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
            withAnimation {
                self.fetchValues()

            }
        }
    }
    
}

struct PlayerView: View {
    
    @ObservedObject var player: Player
    @State var show = false
    @ObservedObject var valueVM = ValueViewModel.shared
    @StateObject var coordinator = ValueCoordinator.shared
    
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
                    
                    if coordinator.show1 {
                        CounterView(size: geo.size, player: player, slot: 1)
                            .transition(
                                ZoomTransition(size: geo.size, x: 0, y: y)
                            )
                            .position(x: 0, y: geo.size.height)
                            
                    }
                    if coordinator.show2 {
                        
                        CounterView(size: geo.size, player: player, slot: 2)
                            .transition(
                                ZoomTransition(size: geo.size, x: x, y: y)
                            )
                            .position(x: x, y: y)
                            
                    }
                }
            }
        }

    }
}

#Preview {
    GameView()
}
