//
//  SavedGames.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/15/26.
//

import SwiftUI
import SwiftData

let monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
]

struct SavedGames: View {
    @Query(sort: \Game.date) private var games: [Game]
    
    
    var groupedGames: [(category: String, games: [Game])] {
        var sortedGames = games.sorted { $0.date > $1.date }
        let todayGames = sortedGames.filter { Calendar.current.isDateInToday($0.date) }
        let yesterdayGames = sortedGames.filter { Calendar.current.isDateInYesterday($0.date) }
        sortedGames.removeAll(where: { todayGames.contains($0) } )
        sortedGames.removeAll(where: { yesterdayGames.contains($0) } )
        
        let groupByYearAndMonth: [String: [Game]] = Dictionary(grouping: sortedGames) {
            let components = Calendar.current.dateComponents([.year, .month], from: $0.date)
            return "\( ( (components.year ?? 2024) == Calendar.current.component(.year, from: Date()) ) ? "" : "\(components.year ?? 2024), " ) \(monthNames[(components.month ?? 1)-1])"
        }
        var mappedGroupedGames = groupByYearAndMonth
            .map { (category: $0.key.description, games: $0.value) }
            .sorted { $0.category > $1.category }
        if todayGames.isEmpty {} else { mappedGroupedGames.append(("Today", todayGames)) }
        if yesterdayGames.isEmpty {} else { mappedGroupedGames.append(("Yesterday", yesterdayGames)) }

        return mappedGroupedGames
            .sorted { $0.1[0].date > $1.1[0].date}
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(edges: .all)
                .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            VStack {
                Text("Saved Games")
                    .heading()
                    .foregroundStyle(.white)
                if !games.isEmpty {
                    List {
                        
                        ForEach(groupedGames, id: \.category) { group in
                            Section(header: Text(group.category).foregroundStyle(.accent)) {
                                ForEach(group.games) { game in
                                    GameRow(game: game)
                                    
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.black.ignoresSafeArea())
                }
                
                if games.isEmpty {
                    Text("No Saved Games")
                        .avenir(17)
                        .foregroundStyle(.accent)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            CustomBackButton()
        }
    }
    
    
}

struct GameRow: View {
    var game: Game
    var body: some View {
        HStack {
            Text(game.date.formatted(date: .numeric, time: .omitted))
                .avenir(17)
            Spacer()
             Button(action: {
                 GameSettings.shared.game = game
                 Path.shared.navPath.append(Route.twoPlayerView)
             }) {
                 Text("Resume")
                     .avenirMedium(17)
                     .foregroundStyle(.white)
                     .padding(.horizontal, 12)
                     .padding(.vertical, 6)
                     .background(Color.accentColor)
                     .cornerRadius(8)
             }
             .buttonStyle(.plain)
             .padding(.leading)
        }
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, configurations: config)

    let game = Game(playerCount: 2, startingLife: 40 )
    let game2 = Game(playerCount: 2, startingLife: 40 )
    game.date = Date(timeIntervalSinceNow: -86400*10)
    container.mainContext.insert(game)
    container.mainContext.insert(game2)


    return SavedGames()
        .modelContainer(container)
}
