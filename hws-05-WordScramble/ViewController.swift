//
//  ViewController.swift
//  hws-05-WordScramble
//
//  Created by Philip Hayes on 6/20/20.
//  Copyright © 2020 PhilipHayes. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // Create an array to store the 12,000 words in start.txt
    var allWords = [String]()
    
    // Keep track of words used during a game
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // Find the game data and load it from the text file into an array
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        // Handle the case where the word file is empty
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    // MARK: - Table view functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    // MARK: - Game functions
    func startGame() {
        // Pick a word at random to begin the game
        title = allWords.randomElement()
        
        // Erase words used in prior games
        usedWords.removeAll(keepingCapacity: true)
        
        // Call numberOfRowsInSection again and cellForRowAt repeatedly
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        // Create an alert to solicit an answer
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
        
            if isOriginal(word: lowerAnswer) {
        
                if isReal(word: lowerAnswer) {
        
                    // Add the word to usedWords array
                    usedWords.insert(answer, at: 0)
        
                    // Animate display of new word at top of table view
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                }
                else {
                    errorTitle = "Not a recognized English word"
                    errorMessage = "You can't just make them up!"
                }
            }
            else {
                errorTitle = "Word already used"
                errorMessage = "Be original!"
            }
        }
        else {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible with available letters"
            errorMessage = "You can't spell \(lowerAnswer) from \(title)"
        }
        
        // Display error message as alert
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    // Check submitted word is possible from available letters
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            }
            else {
                return false
            }
        }
        
        return true
    }
    
    // Check for duplicate word
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    // Check that word is valid English
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}

