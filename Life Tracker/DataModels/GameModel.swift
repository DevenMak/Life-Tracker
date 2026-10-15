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
    
    init(playerCount: Int, startingLife: Int) {
        self.id = UUID()
        self.date = Date()
        self.players = []
        
        for i in 1...playerCount {
            let player = Player(order: i, life: startingLife)
            let tallyNames = ["poison", "storm", "energy", "custom"]
            for name in tallyNames {
                let tally = Tally(name: name)
                player.tallies.append(tally)
            }
            self.players.append(player)
        }
    }
}
