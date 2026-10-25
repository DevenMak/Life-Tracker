//
//  PlayerModel.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import Foundation
import SwiftData

@Model
class Player {
    var comDamages: [Int] = [0,0,0,0,0]
    var order: Int
    var life: Int
    @Relationship(deleteRule: .cascade, inverse: \Tally.player)
    var tallies: [Tally] = []
    var game: Game?
    
    init(order: Int, life: Int) {
        self.order = order
        self.life = life
    }
}
