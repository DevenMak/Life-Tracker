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
        }
        save()
    }
    
    func fetchValues() {
        let request = NSFetchRequest<Value>(entityName: "Value")
        do {
            self.values = try self.manager.context.fetch(request)  // sets ALL values
            if let gameValues = self.game?.values?.allObjects as? [Value] {
                self.values = gameValues  // then immediately overwrites with game values
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
        
        if let playerValues = player.values?.allObjects as? [Value] {
            for value in playerValues {
                if value.name == name && value.iconName == iconName{
                    return
                }
            }
        }
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
        
        withAnimation {
            manager.context.delete(value)
            save()
        }
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
        let allowedValues = 1
        withAnimation {
            if values.contains(where: {$0.name == name}) && !custom {
                deleteValueFromGame(name)
            } else {
                if(values.count >= allowedValues) {
                    deleteValueFromGame(values.first!.name!)
                }
                DispatchQueue.main.async {
                    self.addValueToPlayers(name, count, iconName, rgb)
                }
            }
        }
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
        
    var playerValues: [Value] {
        valueVM.values.filter { $0.player?.objectID == player.objectID }
    }
       
    var body: some View {
        ZStack {
            UnevenRoundedRectangle(10, 0, 0, 10)
                .fill(.white)
            HStack(spacing: 0) {
                if let value = playerValues.first {
                    
                    ValueView(player: player, value: value)
                        .frame(maxWidth: 100)
                        .transition(.move(edge: .leading))
                        
                }
                ZStack {
                    VStack(spacing: 0) {
                        Button(action: {
                            PlayerViewModel.shared.addLife(player)
                        }) {
                            UnevenRoundedRectangle(ValueViewModel.shared.fetchPlayerValues(player).isEmpty ? 10 : 0,0,0,10)
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
                }
            }
        }

    }
}

#Preview {
    GameView()
}
