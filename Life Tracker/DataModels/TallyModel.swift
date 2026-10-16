//
//  TallyModel.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import Foundation
import SwiftData

@Model
class Tally {
    var name: String
    var value: Int
    var order: Int
    var player: Player?
    var game: Game?
    
    init(name: String, order: Int = 0, value: Int = 0) {
        self.value = value
        self.name = name
        self.order = order
    }
    
    init(game: Game, player: Player, name: String, order: Int = 0, value: Int = 0) {
        self.game = game
        self.player = player
        self.value = value
        self.name = name
        self.order = order
    }
}
