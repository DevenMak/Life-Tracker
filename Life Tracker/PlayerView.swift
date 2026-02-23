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
        do {
            try context.save()
        } catch let error {
            print("Error saving Core Data: \(error)")
        }
    }
}

class GameViewModel: ObservableObject {
    static var playerCount = 0
    let manager = CoreDataManager.instance
    @Published var players: [Player] = []
    
    init() {
        clearPlayers()
        addPlayer(0)
        
    }
    
    func clearPlayers() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        
        do {
            try manager.context.execute(NSBatchDeleteRequest(fetchRequest: request))
            
        } catch {}
        save()
    }
    
    func fetchPlayers() {
        let request = NSFetchRequest<Player>(entityName: "Player")
        
        do {
            players = try manager.context.fetch(request)
        } catch let error {
            print(error)
        }
    }
    
    func addPlayer(_ life: Int) {
        let player = Player(context: manager.context)
        player.number = Int16(GameViewModel.playerCount)
        player.life = Int16(life)
        GameViewModel.playerCount += 1
        save()
    }
    
    func save() {
        manager.save()
        fetchPlayers()
    }
}

struct GameView: View {
    @StateObject var vm = GameViewModel()
    var body: some View {
        PlayerView(player: vm.players[0])
    }
}

struct PlayerView: View {
    
    let player: Player
    
    var body: some View {
        Text("\(player.life)")
    }
}

#Preview {
    GameView()
}
