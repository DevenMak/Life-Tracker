//
//  Life_TrackerApp.swift
//  Life Tracker
//
//  Created by Deven Mak on 2/20/26.
//

import SwiftUI
import SwiftData

@main
struct Life_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Player.self)
        .modelContainer(for: Tally.self)
        .modelContainer(for: Game.self)
    }
}
