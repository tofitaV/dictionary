//
//  AddWordTabView.swift
//  SuperDict
//
//  Created by Vladyslav on 29.10.2023.
//

import Foundation
import SwiftUI

struct AddWordTabView: View {
    @EnvironmentObject var wordList: WordList
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var text = ""
    @State private var showMessage = false
    @State private var showAlert = false
    @FocusState private var focusedField: Bool?
    
    var body: some View {
        NavigationView {
            VStack() {
                Spacer()
                TextField("Enter a new word", text: $text)
                    .padding(.bottom)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                        DispatchQueue.main.async {
                            text = ""
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                focusedField = true
                            }
                        }
                    }
                    .focused($focusedField, equals: true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    if !text.isEmpty {
                        if wordList.wordExisting(text, context: managedObjectContext) {
                            showAlert = true
                        } else {
                            wordList.saveWordToCoreData(text, false, context: managedObjectContext)
                            text = ""
                            showMessage = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showMessage = false
                            }
                            hideKeyboard()
                        }
                    }
                } label: {
                    Text("Add to dictionary")
                        .frame(maxWidth: .infinity)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Duplicate Word"),
                        message: Text("The word '\(text)' already exists in the dictionary"),
                        dismissButton: .default(Text("Ok"))
                
                    )
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
            }
            .padding()
            .overlay(
                VStack {
                    if showMessage {
                        Text("Word '\(wordList.words.last?.name ?? "Oppss...")' added to dictionary.")
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .padding()
                            .background(Color.secondary.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.opacity)
                    }
                }
            )
            .navigationTitle("Add new word")
            
        }
        .onTapGesture {
            hideKeyboard()
        }
        
    }
        
}
