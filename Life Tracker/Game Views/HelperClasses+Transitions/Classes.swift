//
//  Classes.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/27/26.
//

import SwiftUI

class MenuState: ObservableObject {
    public static var shared = MenuState()
    @Published var showMenu: Bool = false
    
    func setShowMenu(_ showMenu: Bool) {
        withAnimation {
            self.showMenu = showMenu
        }
    }
}

class TallyTracker: ObservableObject {
    public static var shared = TallyTracker()
    @Published var orderToBeRemoved: Int = 1
}

class Path: ObservableObject {
    public static var shared = Path()
    @Published var navPath = NavigationPath()
}

class GameSettings: ObservableObject {
    public static var shared = GameSettings()
    @Published var playerCount: Int = 0
    @Published var startingLife: Int = 0
    @Published var commander: Bool = false
    @Published var game: Game?
}
