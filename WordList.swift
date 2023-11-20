//
//  WordList.swift
//  SuperDict
//
//  Created by Vladyslav on 31.10.2023.
//

import Foundation
import CoreData

class WordList: ObservableObject {
    @Published var words = [Word]()
    
    func getWord(_ word: Word) -> Word? {
        return words.first { $0 == word }
    }
    
    func saveWordToCoreData(_ wordName: String, _ isFavourite: Bool, context: NSManagedObjectContext) {
        let newWord = WordEntity(context: context)
        newWord.name = wordName
        newWord.isFavourite = isFavourite
        try? context.save()
        loadWordsFromCoreData(context: context)
    }
    
    func loadWordsFromCoreData(context: NSManagedObjectContext) {
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        do {
            let wordEntities = try context.fetch(request)
            words = wordEntities.map { Word(id: $0.id ?? UUID(), name: $0.name ?? "", isFavourite: $0.isFavourite) }
        } catch {
            print("Error fetching words: \(error)")
        }
    }
    
    func deleteWordFromCoreData(_ word: Word, context: NSManagedObjectContext) {
        if let entity = fetchWordEntity(word.name, context: context) {
            context.delete(entity)
            try? context.save()
            loadWordsFromCoreData(context: context)
        }
    }
    
    func markAsFavouriteWordInCoreData(_ word: Word, context: NSManagedObjectContext) {
        if let entity = fetchWordEntity(word.name, context: context) {
            entity.isFavourite.toggle()
            try? context.save()
            loadWordsFromCoreData(context: context)
        }
    }
    
    
    func fetchWordEntity(_ wordName: String, context: NSManagedObjectContext) -> WordEntity? {
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", wordName as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching word entity: \(error)")
            return nil
        }
    }
    
    func wordExisting(_ wordName: String, context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()

        do {
            let wordEntities = try context.fetch(request)
            return wordEntities.contains { $0.name?.localizedCaseInsensitiveContains(wordName) == true }
        } catch {
            print("Error checking if word exists in Core Data: \(error)")
            return false
        }
    }

    
    
}
