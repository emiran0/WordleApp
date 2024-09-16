//
//  ContentView.swift
//  WordleApp
//
//  Created by Emiran Kartal on 16.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var guesses: [[Letter]] = Array(
        repeating: Array(repeating: Letter(char: " ", color: .gray.opacity(0.3)), count: 5),
        count: 6
    )
    @State private var currentGuess: String = ""
    @State private var currentRow: Int = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Load the word list and select a random word to guess
    let wordList: [String] = WordList.shared.words
    let wordToGuess: String
    
    init() {
        wordToGuess = wordList.randomElement() ?? "APPLE"
        print("Word to guess: \(wordToGuess)") // For debugging purposes
    }
    
    var body: some View {
        VStack {
            // Display the grid of letters
            ForEach(0..<6, id: \.self) { row in
                HStack {
                    ForEach(0..<5, id: \.self) { col in
                        Text(String(guesses[row][col].char))
                            .frame(width: 50, height: 50)
                            .background(guesses[row][col].color)
                            .border(Color.black)
                            .font(.largeTitle)
                    }
                }
            }
            Spacer()
            // Include the custom keyboard
            KeyboardView(onKeyPress: handleKeyPress)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage))
        }
    }
    
    // Function to handle key presses from the keyboard
    func handleKeyPress(_ key: String) {
        if key == "ENTER" {
            if currentGuess.count == 5 {
                if isValidWord(currentGuess) {
                    checkGuess()
                    currentGuess = ""
                    currentRow += 1
                } else {
                    alertMessage = "Invalid Word"
                    showAlert = true
                }
            } else {
                alertMessage = "Not enough letters"
                showAlert = true
            }
        } else if key == "DELETE" {
            if !currentGuess.isEmpty {
                currentGuess.removeLast()
                guesses[currentRow][currentGuess.count].char = " "
            }
        } else if currentGuess.count < 5 {
            currentGuess.append(key)
            updateGuesses()
        }
    }
    
    // Update the guesses array with the current guess
    func updateGuesses() {
        for (index, char) in currentGuess.enumerated() {
            guesses[currentRow][index].char = char
        }
        for index in currentGuess.count..<5 {
            guesses[currentRow][index].char = " "
        }
    }
    
    // Validate if the word is in the word list
    func isValidWord(_ word: String) -> Bool {
        return wordList.contains(word.uppercased())
    }
    
    // Check the user's guess against the word to guess
    func checkGuess() {
        let guess = currentGuess.uppercased()
        let target = Array(wordToGuess)
        var letterColors = [Color](repeating: .gray.opacity(0.3), count: 5)
        var targetLetterCounts = [Character: Int]()
    
        // Count letters in the target word
        for char in target {
            targetLetterCounts[char, default: 0] += 1
        }
    
        // First pass: Check for correct positions (green)
        for i in 0..<5 {
            let guessChar = guess[guess.index(guess.startIndex, offsetBy: i)]
            if guessChar == target[i] {
                letterColors[i] = .green
                targetLetterCounts[guessChar]! -= 1
            }
        }
    
        // Second pass: Check for wrong positions (yellow)
        for i in 0..<5 {
            let guessChar = guess[guess.index(guess.startIndex, offsetBy: i)]
            if letterColors[i] != .green,
               targetLetterCounts[guessChar, default: 0] > 0 {
                letterColors[i] = .yellow
                targetLetterCounts[guessChar]! -= 1
            }
        }
    
        // Update the guesses array with colors
        for i in 0..<5 {
            guesses[currentRow][i].color = letterColors[i]
        }
    
        // Check if the game is over
        if guess == wordToGuess {
            alertMessage = "🎉 Congratulations! You guessed the word."
            showAlert = true
        } else if currentRow >= 5 {
            alertMessage = "😞 Game Over! The word was \(wordToGuess)."
            showAlert = true
        }
    }
}

#Preview {
    ContentView()
}
