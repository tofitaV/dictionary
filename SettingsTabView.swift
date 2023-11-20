import SwiftUI

struct SettingsTabView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        Toggle("Night mode", isOn: $settings.appNightMode)
                            .onChange(of: settings.appNightMode) { newValue in
                                settings.saveNightModeState(context: managedObjectContext)
                            }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
