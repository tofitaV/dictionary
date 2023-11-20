import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var wordList: WordList
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var selectedTab = 2
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AddWordTabView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Word")
                }
                .tag(0)
            
            FavoriteTabView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorite")
                }
                .tag(1)
            
            HomeTabView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(2)
            
            SettingsTabView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .onAppear {
            settings.loadNightModeState(context: managedObjectContext)
        }
        .preferredColorScheme(settings.colorForNightMode())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PageView<Content: View>: View {
    let title: String
    let imageName: String
    let content: Content
    
    init(title: String, imageName: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.imageName = imageName
        self.content = content()
    }
    
    var body: some View {
        content
            .tabItem {
                Image(systemName: imageName)
                Text(title)
            }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
