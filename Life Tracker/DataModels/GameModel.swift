//
//  GameModel.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import Foundation
import SwiftData
import SwiftUICore

@Model
class Game {
    var id: UUID
    @Relationship(deleteRule: .cascade, inverse: \Player.game)
    var players: [Player]
    var date: Date
    var commander: Bool
    
    init(playerCount: Int, startingLife: Int, commander: Bool = false) {
        self.id = UUID()
        self.date = Date()
        self.players = []
        self.commander = commander
        
        for i in 1...playerCount {
            let player = Player(order: i, life: startingLife)
            let tallyNames = ["poison", "storm", "energy", "custom"]
            for name in tallyNames {
                let tally = Tally(name: name)
                player.tallies.append(tally)
            }
            if commander {
                player.tallies.append(Tally(name: "commander", order: 1))
            }
            self.players.append(player)
        }
    }
}
