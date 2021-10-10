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
        for _ in 0...11 {
            currentlyDisplayedCards.append(getRandomCard())
            
        }
        if (!checkThatAMatchExists(with: currentlyDisplayedCards)) {
            // We need to add a match
            let replaceCardIndex = Int.random(in: 0...11)
            let randomIndices = getRandomIndices(bottomRange: 0, topRangeInclusive: 11, excluding: [replaceCardIndex])
            currentlyDisplayedCards[replaceCardIndex] = createMatch(card1: currentlyDisplayedCards[randomIndices[0]], card2: currentlyDisplayedCards[randomIndices[1]]);
        }
    }
    
    func getRandomIndices(bottomRange: Int, topRangeInclusive: Int, excluding: [Int], _ numberOfIndices: Int = 2) -> [Int]{
        var randomIndex1: Int = Int.random(in: bottomRange...topRangeInclusive)
        if (excluding.contains(randomIndex1)) {
            if (Int.random(in: 0...1) == 0) {
                while excluding.contains(randomIndex1) {
                    if (randomIndex1 == bottomRange) {
                        randomIndex1 = topRangeInclusive
                    } else {
                        randomIndex1 = randomIndex1 - 1
                    }
                }
            } else {
                while excluding.contains(randomIndex1) {
                    if (randomIndex1 == topRangeInclusive) {
                        randomIndex1 = bottomRange
                    } else {
                        randomIndex1 = randomIndex1 + 1
                    }
                }
            }
        }
        var randomIndex2: Int = Int.random(in: bottomRange...topRangeInclusive)
        if (randomIndex2 == randomIndex1 || excluding.contains(randomIndex2)) {
            if (Int.random(in: 0...1) == 0) {
                while excluding.contains(randomIndex2) {
                    if (randomIndex2 == bottomRange) {
                        randomIndex2 = topRangeInclusive
                    } else {
                        randomIndex2 = randomIndex2 - 1
                    }
                }
            } else {
                while excluding.contains(randomIndex2) {
                    if (randomIndex2 == topRangeInclusive) {
                        randomIndex2 = bottomRange
                    } else {
                        randomIndex2 = randomIndex2 + 1
                    }
                }
            }
        }
        if (numberOfIndices == 2) {
            return [randomIndex1, randomIndex2]
        } else {
            var randomIndex3: Int = Int.random(in: bottomRange...topRangeInclusive)
            if (randomIndex3 == randomIndex2 || randomIndex3 == randomIndex1 || excluding.contains(randomIndex3)) {
                if (Int.random(in: 0...1) == 0) {
                    while excluding.contains(randomIndex3) || randomIndex3 == randomIndex2 || randomIndex3 == randomIndex1 {
                        if (randomIndex3 == bottomRange) {
                            randomIndex3 = topRangeInclusive
                        } else {
                            randomIndex3 = randomIndex2 - 1
                        }
                    }
                } else {
                    while excluding.contains(randomIndex3) || randomIndex3 == randomIndex2 || randomIndex3 == randomIndex1 {
                        if (randomIndex3 == topRangeInclusive) {
                            randomIndex3 = bottomRange
                        } else {
                            randomIndex3 = randomIndex2 + 1
                        }
                    }
                }
            }
            return [randomIndex1, randomIndex2, randomIndex3]
        }
        
    }
    
    func createMatch(card1: Card, card2: Card) -> Card {
        // This function replaces one card from the array to make a match from two randomly selected cards
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
        return newCard
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
    
    mutating func deal3MoreCards() {
        // Check if they have three cards selected
        let chosenCards: [Card] = currentlyDisplayedCards.filter { $0.isChosen == true }
        if (chosenCards.count == 3) {
            // Check if they are matched
            var areMatches: Bool = false
            for card in chosenCards {
                if card.isMatched == false {
                    areMatches = false
                    break
                } else {
                    areMatches = true
                }
            }
            if areMatches {
                // Replace the three chosen cards
                currentlyDisplayedCards = getCorrectCards(cards: currentlyDisplayedCards, cardsToRemove: chosenCards)
                return
            }
        }
        
        // Display 3 new cards but not in the position of those already chosen
        var excludedCardsIndices: [Int] = []
        for card in chosenCards {
            excludedCardsIndices.append(index(of: card) ?? 0)
        }
        let randomIndices = getRandomIndices(bottomRange: 0, topRangeInclusive: 11, excluding: excludedCardsIndices, 3)
        currentlyDisplayedCards = getCorrectCards(cards: currentlyDisplayedCards, cardsToRemove: [
            currentlyDisplayedCards[randomIndices[0]],
            currentlyDisplayedCards[randomIndices[1]],
            currentlyDisplayedCards[randomIndices[2]]
        ])
    }
    
    mutating func toggleChosen(card: Card) {
        let actualCardIndex: Int = index(of: card) ?? 0
        let chosenCards: [Card] = currentlyDisplayedCards.filter {
            $0.isChosen == true
        }
        if (chosenCards.count <= 2) {
            if currentlyDisplayedCards[actualCardIndex].isChosen {
                currentlyDisplayedCards[actualCardIndex].isChosen = false
            } else {
                currentlyDisplayedCards[actualCardIndex].isChosen = true
            }
            
            let newChosenCards: [Card] = currentlyDisplayedCards.filter {
                $0.isChosen == true
            }
            
            if (newChosenCards.count == 3) {
                if (checkIsMatch(with: newChosenCards)) {
                    // They made a match
                    for card in newChosenCards {
                        currentlyDisplayedCards[index(of: card) ?? 0].isMatched = true
                    }
                } else {
                    // They did not make a match so do something
                    for card in newChosenCards {
                        currentlyDisplayedCards[index(of: card) ?? 0].isNotAMatch = true
                    }
                }
            }
        } else {
            // They either made a match recently or they didn't
            if (checkIsMatch(with: chosenCards)) {
                // They made a match
                // Replace those three cards
                currentlyDisplayedCards = getCorrectCards(cards: currentlyDisplayedCards, cardsToRemove: chosenCards)
            } else {
                // They did not make a match :(
                for card in chosenCards {
                    currentlyDisplayedCards[index(of: card) ?? 0].isChosen = false
                    currentlyDisplayedCards[index(of: card) ?? 0].isNotAMatch = false
                }
            }
            
            // Toggle the card they just touched
            currentlyDisplayedCards[actualCardIndex].isChosen = !currentlyDisplayedCards[actualCardIndex].isChosen
        }
    }
    
    func getCorrectCards(cards: [Card], cardsToRemove: [Card]) -> [Card] {
        var cardsToAdd = [getRandomCard(), getRandomCard(), getRandomCard()]
        
        var potentialCards = cards
        for loopIndex in 0...2 {
            let cardIndex: Int = index(of: cardsToRemove[loopIndex]) ?? 0
            potentialCards[cardIndex] = cardsToAdd[loopIndex]
        }
        
        // Check that a match will exist
        if (checkThatAMatchExists(with: potentialCards) == false) {
            let randomIndices = getRandomIndices(
                bottomRange: 0,
                topRangeInclusive: 11,
                excluding: [index(of: cardsToRemove[0]) ?? 0, index(of: cardsToRemove[1]) ?? 1, index(of: cardsToRemove[2]) ?? 2]
            )
            cardsToAdd[0] = createMatch(card1: cards[randomIndices[0]], card2: cards[randomIndices[1]])
            cardsToAdd = cardsToAdd.shuffled()
            
            for loopIndex in 0...2 {
                potentialCards[index(of: cardsToRemove[loopIndex]) ?? 0] = cardsToAdd[loopIndex]
            }
        }
        
        return potentialCards
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
    var isNotAMatch: Bool = false // For displaying if this is not a potential match
}
