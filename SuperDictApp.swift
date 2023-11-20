//
//  SuperDictApp.swift
//  SuperDict
//
//  Created by Vladyslav on 22.10.2023.
//

import SwiftUI

struct Word: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var translation: String
    var isFavourite: Bool
    
    init(name: String) {
        self.name = name
        self.isFavourite = false
        self.translation = "test"
    }
    
    init(id: UUID, name: String, isFavourite: Bool) {
        self.id = id
        self.name = name
        self.isFavourite = isFavourite
        self.translation = "test"
    }
}


@main
struct SuperDictApp: App {
    @StateObject var settings = Settings()
    @StateObject var wordList = WordList()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .environmentObject(wordList)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
