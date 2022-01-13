//
//  ContentView.swift
//  WordScramble
//
//  Created by liuyihua on 2022/1/13.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0.0

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    func startGame() {
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                
                return
            
            }
        }
        
        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func addNewWord() {
        
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard isShort(word: answer) else {
            wordError(title: "字母长度", message: "不允许短于三个字母或只是我们的起始词的答案")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard answer.count > 0 else {return}
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        getScore(answer: answer)
        
        newWord = ""
    }
    
    func getScore(answer:String){
        
        let answers = Double(answer.count)
        
        let rootWords = Double(rootWord.count)

        score = answers / rootWords;
    }
    
//    不允许短于三个字母或只是我们的起始词的答案。
    func isShort(word: String) -> Bool {
        return rootWord != word && word.count > 2

    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text(score,format:.percent)
                }
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)

                }
                Section{
                    ForEach(usedWords,id: \.self) {word in
                        HStack {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("开始",action: startGame)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
