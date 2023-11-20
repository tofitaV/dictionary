//
//  FavoriteTabView.swift
//  SuperDict
//
//  Created by Vladyslav on 29.10.2023.
//

import Foundation
import SwiftUI

struct FavoriteTabView: View {
    @EnvironmentObject var wordList: WordList
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { word in
                    HStack {
                        Text(word.name)
                        Button(action: {
                            wordList.markAsFavouriteWordInCoreData(word, context: managedObjectContext)
                        }) {
                            Image(systemName: word.isFavourite ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .searchable(text: $searchText)
    }

    var searchResults: [Word] {
        if searchText.isEmpty {
            return wordList.words.filter { $0.isFavourite == true }
        } else {
            let filteredWords = wordList.words.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) && $0.isFavourite == true
            }
            return filteredWords
        }
    }
}

