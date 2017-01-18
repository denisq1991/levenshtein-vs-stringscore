//
//  ViewController.swift
//  levenshtein-search-suggestions
//
//  Created by Denis Quaid on 18/01/2017.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var searchBox: UITextField!
    @IBOutlet private weak var searchedTextLabel: UILabel!
    @IBOutlet private weak var closestMatchesLabel: UILabel!
    @IBOutlet private weak var levenshteinMatchesLabel: UILabel!
    @IBOutlet private weak var scoreLibraryTitle: UILabel!
    @IBOutlet private weak var levenshetinTitle: UILabel!
    
    private var latestSearch : String?
    // Add the desired words to be matched to this array
    private var wordsArray = ["example"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBox.delegate = self
        self.searchBox.autocorrectionType = .no
        self.searchedTextLabel.text = ""
        self.closestMatchesLabel.text = ""
        self.closestMatchesLabel.textColor = UIColor.red
        self.levenshteinMatchesLabel.text = ""
        self.levenshteinMatchesLabel.textColor = UIColor.red
        
        self.scoreLibraryTitle.isHidden = true
        self.levenshetinTitle.isHidden = true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.latestSearch = textField.text
        self.searchedTextLabel.text = "You searched for: \(self.latestSearch!)"
        
        // Levenshtein Version
        let unsortedLevenshteinTupleArray = self.levenshteindDictionary(array: self.wordsArray, stringToMatch: self.latestSearch!)
        let sortedLevenshteinTupleArray = unsortedLevenshteinTupleArray.sorted { (left, right) -> Bool in
            // left.1 is the tuple on the left, index 1. Eg for ("burberry", 7) and ("eres", 4) left.1 and right.1
            return left.1 < right.1
        }
        
        let stringArray = sortedLevenshteinTupleArray.map({ ("\($0) scores \($1)") })
        let levenshteinResultsString = stringArray.joined(separator: "\n")
        self.levenshteinMatchesLabel.text = levenshteinResultsString
        self.levenshetinTitle.isHidden = false
        
        // Score Version
        let unsortedScoreTupleArray = self.indexedDictionary(array: self.wordsArray, stringToMatch: self.latestSearch!)
        let sortedScoreTupleArray = unsortedScoreTupleArray.sorted { (left, right) -> Bool in
            return left.1 > right.1
        }
        
        let scoreStringArray = sortedScoreTupleArray.map({ ("\($0) scores \(ceil($1))") })
        let scoreResultsString = scoreStringArray.joined(separator: "\n")
        self.closestMatchesLabel.text = scoreResultsString
        self.scoreLibraryTitle.isHidden = false
        
        return true
    }
    
    private func indexedDictionary(array: [String], stringToMatch: String)  -> [(String, CGFloat)]  {
        var tupleArray = [(String, CGFloat)]()
        wordsArray.forEach({
            let score = $0.lowercased().scoreAgainst(stringToMatch)
            let roundedScore = CGFloat(round(100*score)/10)
            let tuple = ($0, roundedScore)
            tupleArray.append(tuple)
        })
        return tupleArray
    }
    
    private func levenshteindDictionary(array: [String], stringToMatch: String)  -> [(String, Int)] {
        var tupleArray = [(String, Int)]()
        wordsArray.forEach({
            let score = $0.lowercased().getLevenshtein(stringToMatch)
            let tuple = ($0, score)
            tupleArray.append(tuple)
        })
        return tupleArray
    }
    
}




