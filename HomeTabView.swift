import SwiftUI

struct HomeTabView: View {
    var body: some View {
        NavigationView {
            VStack {
                WordGridView()
            }
            .navigationTitle("Your dictionary")
        }
    }
}

struct WordGridView: View {
    @EnvironmentObject var wordList: WordList
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var searchText = ""
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)], spacing: 16) {
                ForEach(searchResults) { word in
                    WordCardView(word: word)
                }
            }
            .padding(16)
            .animation(Animation.easeInOut, value: UUID())
        }
        .onAppear {
            wordList.loadWordsFromCoreData(context: managedObjectContext)
        }
        .searchable(text: $searchText   )
    }

    var searchResults: [Word] {
        searchText.isEmpty ? wordList.words : wordList.words.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}

struct WordCardView: View {
    let word: Word
    @State private var isFlipped = false

    var body: some View {
        VStack {
            ZStack {
                CardViewSides(name: word.name, translation: word.translation, isFlipped: $isFlipped)
            }
            .clipShape(RoundedRectangle(cornerRadius: 13.0, style: .continuous))
            .rotation3DEffect(
                isFlipped ? Angle(degrees: 180) : .zero,
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .animation(.default, value: isFlipped)
            .onTapGesture {
                withAnimation {
                    isFlipped.toggle()
                }
            }
        }
        .multilineTextAlignment(.center)
        .shadow(radius: 3)
    }
}

struct CardViewSides: View {
    let name: String
    let translation: String?
    @Binding var isFlipped: Bool

    var body: some View {
        ZStack {
            CardSideView(content: name, isFlipped: $isFlipped)
                .opacity(isFlipped ? 0 : 1)
            CardSideView(content: translation ?? "", isFlipped: $isFlipped)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 0.0, y: 1.0, z: 0.0))
        }
    }
}

struct CardSideView: View {
    let content: String
    @Binding var isFlipped: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 13.0, style: .continuous)
            .fill(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .overlay(
                Text(content)
                    .foregroundColor(.black)
                    .padding()
            )
            .frame(width: 100, height: 150)
    }
}
