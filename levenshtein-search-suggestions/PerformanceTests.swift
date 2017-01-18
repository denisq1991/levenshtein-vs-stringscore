//
//  PerformanceTests.swift
//  levenshtein-search-suggestions
//
//  Created by Denis Quaid on 19/01/2017.
//

import XCTest


class PerformanceTests: XCTestCase {
    
    private var wordsArray = ["BOBBI BROWN", "BODYISMBODYISM'S CLEAN AND LEAN", "BOMBKI", "BURBERRY", "BURBERRY BEAUTY", "BOTTEGA VENETA", "BALMAIN", "BULY 1803", "BYREDO"]
    
    func testLevenshteinPerformance() {
        self.measure {
            for _ in 1...10000 {
                self.levenshteindDictionary(array: self.wordsArray, stringToMatch: "Burb")
            }
        }
    }
    
    func testScoreAlgorithmPerformance() {
        self.measure {
            for _ in 1...10000 {
                self.indexedDictionary(array: self.wordsArray, stringToMatch: "Burb")
            }
        }
        
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
