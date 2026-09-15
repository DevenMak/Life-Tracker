//
//  SavedGames.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/25/26.
//

import SwiftUI
import CoreData
import Foundation

class GameCollection {
    var name: String
    var games: [Game]
    
    init(name: String, games: [Game]) {
        self.name = name
        self.games = games
    }
}

class GameViewModel: ObservableObject {
    public static var shared = GameViewModel()
    @Published var savedGames: [Game] = []
    @Published var currentGame: Game?
    let manager = CoreDataManager.instance
    
    init() {
        fetchGames()
    }
    func fetchGames() {
        let request = NSFetchRequest<Game>(entityName: "Game")
        do {
            
            self.savedGames = try self.manager.context.fetch(request)
            
        } catch {}
    }
    func addGame() {
        let game = Game(context: manager.context)
        game.date = Date()
        game.name = "Untitled"
        currentGame = game
        save()
    }
    
    func changeGameName(game: Game, name: String) {
        game.name = name
        save()
    }
    
    func dateAsString(date: Date) -> String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return (formatter1.string(from: date))
    }
    
    func isDateInThisWeek(_ date: Date) -> Bool {
        let calendar = Calendar.current
        // Returns the entire 7-day interval containing the date
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else { return false }
        
        return weekInterval.contains(date)
    }
    
    func isDateInThisMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        
        let isSameMonth = calendar.isDate(date, equalTo: Date(), toGranularity: .month)
        
        return isSameMonth
    }
    
    func isDateInYear(date: Date, year: Int) -> Bool {
        let yearOfGame = Calendar.current.component(.year, from: date)
        
        return yearOfGame == year
    }
    
    func setPlayerCount(_ count: Int) {
        currentGame?.playerCount = Int16(count)
        save()
    }
    
    let monthNames: [String] = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    
    func sortGames() -> [GameCollection] {
        var sortedGames: [GameCollection] = []
        var processedGames: [Game] = []
        let calendar = Calendar.current
        var years: [Int] = []
        for game in savedGames {
            let yearOfGame = Calendar.current.component(.year, from: game.date!)
            if !years.contains(yearOfGame) {
                years.append(yearOfGame)
            }
        }
        let todayGames: [Game] = savedGames.filter { calendar.isDateInToday($0.date!) }
        processedGames.append(contentsOf: todayGames)
        sortedGames.append(GameCollection(name: "Today", games: todayGames))
        
        let yesterdayGames: [Game] = savedGames.filter { calendar.isDateInYesterday($0.date!) && !processedGames.contains($0)}
        processedGames.append(contentsOf: yesterdayGames)
        sortedGames.append(GameCollection(name: "Yesterday", games: yesterdayGames))
        
        let thisWeekGames: [Game] = savedGames.filter { isDateInThisWeek($0.date!) && !processedGames.contains($0)}
        processedGames.append(contentsOf: thisWeekGames)
        sortedGames.append(GameCollection(name: "This Week", games: thisWeekGames))
        
        let thisMonth: Int = calendar.component(.month, from: Date())
        for month in 1...12 {
            let gamesInMonth: [Game] = savedGames.filter { calendar.component(.month, from: $0.date!) == month && !processedGames.contains($0)}
            processedGames.append(contentsOf: gamesInMonth)
            let collectionName = month == thisMonth ? "This Month" : "\(monthNames[month-1])"
            sortedGames.append(GameCollection(name: collectionName, games: gamesInMonth))
        }
        
        let thisYearGames: [Game] = savedGames.filter { isDateInYear(date: $0.date!, year: calendar.component(.year, from: Date())) && !processedGames.contains($0)}
        processedGames.append(contentsOf: thisYearGames)
        sortedGames.append(GameCollection(name: "This Year", games: thisYearGames))
        
        for yr in years {
            let gamesInYear = savedGames.filter { isDateInYear(date: $0.date!, year: yr) && !processedGames.contains($0)}
            processedGames.append(contentsOf: gamesInYear)
            sortedGames.append(GameCollection(name: "\(yr)", games: gamesInYear))
        }
        sortedGames = sortedGames.filter { $0.games.count > 0}
        for collection in sortedGames {
            collection.games.sort(by: { $0.date! > $1.date!})
        }
        sortedGames.sort(by: {$0.games.first!.date! > $1.games.first!.date!})
        return sortedGames
        
    }
    
    func deleteGame(_ game: Game) {
        manager.context.delete(game)
        save()
    }
        
    func save() {
        manager.save()
        fetchGames()
    }
}

class Settings: ObservableObject {
    @Published var autoSave = false {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(autoSave) {
                UserDefaults.standard.set(encoded, forKey: "autoSave")
            }
        }
    }
    init() {
        if let savedAutoSave = UserDefaults.standard.data(forKey: "autoSave") {
            if let decodedAutoSave = try? JSONDecoder().decode(Bool.self, from: savedAutoSave) {
                autoSave = decodedAutoSave
            }
        }
    }
}
struct SavedGames: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var backButtonPlacement: ToolbarItemPlacement {
         ToolbarItemPlacement.navigationBarLeading
     }
    @StateObject var gameVM = GameViewModel.shared
    var sortedGames: [GameCollection] {
        gameVM.sortGames()
    }
    @StateObject var settings = Settings()
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
                    .padding(.bottom, -10)
                ZStack {
                    VStack {
                        HStack {
                            Toggle(isOn: $settings.autoSave) {
                                Text("Auto Save")
                                    .regular()
                                    .foregroundStyle(.accent)
                            }
                            .tint(.accent)
                        }
                        .frame(maxWidth: 150, maxHeight: 55)
                        .padding(.horizontal)
                        .background(.regularMaterial)
                        .cornerRadius(20)
                        
                        
                        List() {
                            ForEach(sortedGames, id: \.games) { collection in
                                Section(header: Text(collection.name).foregroundStyle(Color.accentColor)) {
                                    ForEach(collection.games, id: \.self) { game in
                                        GameRow(game: game)
                                    }
                                    .onDelete { indexSet in
                                        for index in indexSet {
                                            gameVM.deleteGame(collection.games[index])
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                        .scrollContentBackground(.hidden)
                        .background(
                            Color.black
                        )
                        
                        .scrollDismissesKeyboard(.immediately)
                    }
                    
                    if gameVM.savedGames.isEmpty {
                        Text("No Games")
                            .body()
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
             ToolbarItem(placement: backButtonPlacement) {
                 Button {
                     self.presentationMode.wrappedValue.dismiss()
                 } label: {
                     Image(systemName: "arrow.left")
                         .resizable()
                         .renderingMode(.template)
                         .frame(width: imageWidth*scale, height: imageHeight*scale)
                         .foregroundStyle(.accent)
                 }
             }
        }

    }
}

struct GameRow: View {
    
    var game: Game
    let characterLimit = 20
    @State private var nameText: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            TextField("Untitled", text: $nameText)
                .regular()
                .lineLimit(1)
                .focused($isFocused)
                .onChange(of: isFocused) {
                    if isFocused == false {
                        if nameText == "" {
                            nameText = "Untitled"
                        }
                    }
                }
                .onChange(of: nameText) { _, newValue in
                    if newValue.count > characterLimit {
                        nameText = String(newValue.prefix(characterLimit))
                    }
                    GameViewModel.shared.changeGameName(game: game, name: nameText)
                }
                .autocorrectionDisabled(true)
                .onAppear {
                    nameText = game.name ?? ""
                }
            Spacer()
            Text(GameViewModel.shared.dateAsString(date: game.date!))
                .small()
            Button(action: {
                isFocused = false
                GameViewModel.shared.currentGame = game
                InitialGameSettings.shared.newGame = false
                PlayerViewModel.shared.setUp(game: game)
                ValueViewModel.shared.setUp(game: game)

                Path.shared.navPath.append(Route.game)
                
            }) {
                Text("Resume")
                    .small()
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
            .padding(.leading)

        }
        .alignmentGuide(.listRowSeparatorLeading) { d in
            d[.leading]
        }
    }
}

#Preview {
    SavedGames()
}
