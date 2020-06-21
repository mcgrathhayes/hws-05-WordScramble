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
        
    }

}
