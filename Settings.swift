import SwiftUI
import CoreData

class Settings: ObservableObject {
    @Published var appNightMode: Bool
    
    init() {
        self.appNightMode = false
        let context = PersistenceController.shared.container.viewContext
        loadNightModeState(context: context)
    }
    
    func colorForNightMode() -> ColorScheme {
        return appNightMode ? .light : .dark
    }
    
    func saveNightModeState(context: NSManagedObjectContext) {
        let environment: EnvironmentEntity
        if let existingEnvironment = try? context.fetch(EnvironmentEntity.fetchRequest()).first {
            environment = existingEnvironment
        } else {
            environment = EnvironmentEntity(context: context)
        }
        environment.nightMode = appNightMode
        try? context.save()
    }
    
    func loadNightModeState(context: NSManagedObjectContext) {
        let request: NSFetchRequest<EnvironmentEntity> = EnvironmentEntity.fetchRequest()
        do {
            let nightModeState = try context.fetch(request)
            if let environmentEntity = nightModeState.first {
                appNightMode = environmentEntity.nightMode
            }
        } catch {
            print("Error fetching night mode state: \(error)")
        }
    }
}
