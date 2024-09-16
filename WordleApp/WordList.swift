//
//  WordList.swift
//  WordleApp
//
//  Created by Emiran Kartal on 16.09.2024.
//

import Foundation

class WordList {
    static let shared = WordList()
    let words: [String]
    
    private init() {
        if let url = Bundle.main.url(forResource: "wordlist", withExtension: "txt"),
           let wordList = try? String(contentsOf: url) {
            words = wordList.components(separatedBy: "\n").filter { $0.count == 5 }
        } else {
            words = []
            print("Word list could not be loaded.")
        }
    }
}
