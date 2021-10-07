//
//  SetGameModel.swift
//  SetGameModel
//
//  Created by Landon Williams on 9/17/21.
//

import Foundation
import SwiftUI

struct SetGame {
    var currentlyDisplayedCards: [Card] = []
    var numberOfCardsMatched: Int = 0
    let listOfColors: [Color] = [.red, .yellow, .blue]
    let listOfShapes: [String] = ["Circle", "Square", "Squiggle"]
    let listOfOpacities: [CGFloat] = [0, 0.5, 1]
    
    init() {
        for _ in 0...15 {
            currentlyDisplayedCards.append(getRandomCard())
            
            if (!checkThatAMatchExists(with: currentlyDisplayedCards)) {
                // We need to add a match
                currentlyDisplayedCards = createRandomMatch(with: currentlyDisplayedCards);
            }
        }
    }
    
    func createRandomMatch(with cards: [Card]) -> [Card] {
        // This function replaces one card from the array to make a match from two randomly selected cards
        let randomIndex1: Int = Int.random(in: 0..<12)
        var randomIndex2: Int = Int.random(in: 0..<12)
        if (randomIndex2 == randomIndex1) {
            if (Int.random(in: 0...1) == 0) {
                if (randomIndex2 == 0) {
                    randomIndex2 = 11
                } else {
                    randomIndex2 = randomIndex2 - 1
                }
            } else {
                if (randomIndex2 == 11) {
                    randomIndex2 = 0
                } else {
                    randomIndex2 = randomIndex2 + 1
                }
            }
        }
        var randomIndex3: Int = Int.random(in: 0..<12)
        if (randomIndex3 == randomIndex1 || randomIndex3 == randomIndex2) {
            if (Int.random(in: 0...1) == 0) {
                while (randomIndex3 != randomIndex1 && randomIndex3 != randomIndex2) {
                    if (randomIndex3 == 0) {
                        randomIndex3 = 11
                    } else {
                        randomIndex3 = randomIndex3 - 1
                    }
                }
            } else {
                while (randomIndex3 != randomIndex1 && randomIndex3 != randomIndex2) {
                    if (randomIndex3 == 11) {
                        randomIndex3 = 0
                    } else {
                        randomIndex3 = randomIndex3 + 1
                    }
                }
            }
        }
        
        func helperFunction<T: Equatable>(card1Value: T, card2Value: T, possibleValues: [T]) -> T {
            // This generic stuff is quite interesting
            // This returns the correct value to match with 2 other values
            if (card1Value == card2Value) {
                return card1Value
            } else {
                var listOfValues: [T] = possibleValues
                
                listOfValues.remove(at: listOfValues.firstIndex(of: card1Value) ?? 0)
                listOfValues.remove(at: listOfValues.firstIndex(of: card2Value) ?? 0)
                
                return listOfValues[0]
            }
        }
        
        let card1 = cards[randomIndex1]
        let card2 = cards[randomIndex2]
        let newNumberOfShapes: Int = helperFunction(
            card1Value: card1.numberOfShapes,
            card2Value: card2.numberOfShapes,
            possibleValues: [Int.random(in: 1...3)]
        )
        let newShape: String = helperFunction(
            card1Value: card1.shape,
            card2Value: card2.shape,
            possibleValues: listOfShapes
        )
        let newOpacity: CGFloat = helperFunction(
            card1Value: card1.opacity,
            card2Value: card2.opacity,
            possibleValues: listOfOpacities
        )
        let newColor: Color = helperFunction(
            card1Value: card1.color,
            card2Value: card2.color,
            possibleValues: listOfColors
        )
        
        let newCard = Card(shape: newShape, numberOfShapes: newNumberOfShapes, color: newColor, opacity: newOpacity)
        var newCards = cards
        newCards[randomIndex3] = newCard
        return newCards
    }
    
    func checkIsMatch(with: [Card]) -> Bool {
        // I'm going to use sets in my set game lol
        
        // This assumes 3 cards
        if (with.count > 2) {
            // Check each card for each attribute
            let card1: Card = with[0]
            let card2: Card = with[1]
            let card3: Card = with[2]
            
            // Number of shapes
            let myNumberOfShapesSet: Set<Int> = [card1.numberOfShapes, card2.numberOfShapes, card3.numberOfShapes]
            if (myNumberOfShapesSet.count == 2) {
                return false
            }
            
            // Color
            let myColorSet: Set<Color> = [card1.color, card2.color, card3.color]
            if (myColorSet.count == 2) {
                return false
            }
            
            // Pattern
            let myPatternSet: Set<CGFloat> = [card1.opacity, card2.opacity, card3.opacity]
            if (myPatternSet.count == 2) {
                return false
            }
            
            // Shape string
            let myShapeStringSet: Set<String> = [card1.shape, card2.shape, card3.shape]
            if (myShapeStringSet.count == 2) {
                return false
            }
            
            // It's a match
            return true
        } else {
            // Not enough cards
            return false
        }
    }
    
    func checkThatAMatchExists (with cards: [Card]) -> Bool {
        for card1 in cards {
            for card2 in cards {
                for card3 in cards {
                    if (checkIsMatch(with: [card1, card2, card3])) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    mutating func choose(card: Card) {
        let actualCardIndex: Int = index(of: card) ?? 0
        let chosenCards: [Card] = currentlyDisplayedCards.filter {
            $0.isChosen == true
        }
        if (chosenCards.count < 3) {
            currentlyDisplayedCards[actualCardIndex].isChosen = true
        } else {
            if (checkIsMatch(with: chosenCards)) {
                // They made a match
                for card in chosenCards {
                    currentlyDisplayedCards[index(of: card) ?? 0].isMatched = true
                    currentlyDisplayedCards.remove(at: index(of: card) ?? 0)
                    numberOfCardsMatched += 1
                    currentlyDisplayedCards.append(getRandomCard())
                }
                if (checkThatAMatchExists(with: currentlyDisplayedCards) == false) {
                    currentlyDisplayedCards = createRandomMatch(with: currentlyDisplayedCards)
                }
            } else {
                // They did not make a match so do something
            }
            
            // Remove all chosen cards
            for card in chosenCards {
                currentlyDisplayedCards[index(of: card) ?? 0].isChosen = false
            }
        }
    }
    
    func getRandomCard() -> Card {
        return Card(
            shape: listOfShapes[Int.random(in: 0...2)],
            numberOfShapes: Int.random(in: 1...3),
            color: listOfColors[Int.random(in: 0...2)],
            opacity: listOfOpacities[Int.random(in: 0...2)]
        )
    }
    
    func index(of targetCard: Card) -> Int? {
        for index in 0 ..< currentlyDisplayedCards.count {
            if currentlyDisplayedCards[index].id == targetCard.id {
                return index
            }
        }
        return nil
    }
}

struct Card: Identifiable {
    let id = UUID()
    let shape: String
    let numberOfShapes: Int
    let color: Color
    let opacity: CGFloat
    var isChosen: Bool = false
    var isMatched: Bool = false
}
