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
        
    }
    
    public mutating func addInitialCards() {
        for _ in 0...11 {
            currentlyDisplayedCards.append(getRandomCard())
            
        }
        if (checkThatAMatchExists(with: currentlyDisplayedCards).numberOfMatches == 0) {
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
                            randomIndex3 = randomIndex3 - 1
                        }
                    }
                } else {
                    while excluding.contains(randomIndex3) || randomIndex3 == randomIndex2 || randomIndex3 == randomIndex1 {
                        if (randomIndex3 == topRangeInclusive) {
                            randomIndex3 = bottomRange
                        } else {
                            randomIndex3 = randomIndex3 + 1
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
                
                if let index = listOfValues.firstIndex(of: card1Value) {
                    listOfValues.remove(at: index)
                }
                if let index = listOfValues.firstIndex(of: card2Value) {
                    listOfValues.remove(at: index)
                }
                
                return listOfValues[0]
            }
        }

        let newNumberOfShapes: Int = helperFunction(
            card1Value: card1.numberOfShapes,
            card2Value: card2.numberOfShapes,
            possibleValues: [1, 2, 3]
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
        
        // Sanity check
        if (!checkIsMatch(with: [card1, card2, newCard])) {
            print("That actually wasn't a match")
        }
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
    
    func checkThatAMatchExists (with cards: [Card]) -> CheckThatAMatchExistsReturnType {
        var numberOfMatches: Int = 0
        var cards = cards
        var cardsWithMatches: [Card] = []
        var setOfMatches: Set<UUID> = Set()
        for card1 in cards {
            for card2 in cards {
                for card3 in cards {
                    let cardArray = [card1, card2, card3]
                    if card1.id != card2.id && card1.id != card3.id && card2.id != card3.id && !setOfMatches.contains(card1.id) && !setOfMatches.contains(card2.id) && !setOfMatches.contains(card3.id){
                        if (checkIsMatch(with: cardArray)) {
                            numberOfMatches += 1
                            for card in cardArray {
                                if let index = index(of: card, in: cards) {
                                    setOfMatches.insert(card.id)
                                    cards.remove(at: index)
                                    cardsWithMatches.append(card)
                                }
                            }
                        }
                        break
                    }
                }
            }
        }
        let returnValue = CheckThatAMatchExistsReturnType(numberOfMatches: numberOfMatches, cardsWithMatches: cardsWithMatches)
        return returnValue
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
            }
        }
        
        // Display 3 new cards but not in the position of those already chosen
        var excludedCardsIndices: [Int] = []
        for card in chosenCards {
            if let index = index(of: card, in: currentlyDisplayedCards) {
                excludedCardsIndices.append(index)
            }
        }
        let randomIndices = getRandomIndices(bottomRange: 0, topRangeInclusive: currentlyDisplayedCards.count - 1, excluding: excludedCardsIndices, 3)
        var numberOfMatchesNeeded = 1
        if (numberOfCardsToWin - numberOfCardsMatched <= 12) {
            numberOfMatchesNeeded = 3
        }
        currentlyDisplayedCards = getCorrectCards(cards: currentlyDisplayedCards, cardsToRemove: [
            currentlyDisplayedCards[randomIndices[0]],
            currentlyDisplayedCards[randomIndices[1]],
            currentlyDisplayedCards[randomIndices[2]]
        ], numberOfMatchesNeeded: numberOfMatchesNeeded)
    }
    
    mutating func toggleChosen(card: Card) {
        let actualCardIndex: Int = index(of: card, in: currentlyDisplayedCards) ?? 0
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
                    numberOfCardsMatched += 3
                    for card in newChosenCards {
                        if let index = index(of: card, in: currentlyDisplayedCards) {
                            currentlyDisplayedCards[index].isMatched = true
                        }
                    }
                } else {
                    // They did not make a match so do something
                    for card in newChosenCards {
                        if let index = index(of: card, in: currentlyDisplayedCards) {
                            currentlyDisplayedCards[index].isNotAMatch = true
                        }
                    }
                }
            }
        } else {
            // They either made a match recently or they didn't
            if (checkIsMatch(with: chosenCards)) {
                // They made a match
                if numberOfCardsToWin - numberOfCardsMatched <= 12 {
                    // Just remove the cards
                    for card in chosenCards {
                        if let index = index(of: card, in: currentlyDisplayedCards) {
                            currentlyDisplayedCards.remove(at: index)
                        }
                    }
                } else {
                    // Replace those three cards
                    if (numberOfCardsMatched > numberOfCardsToWin-13) {
                        var cardsToCheck: [Card] = []
                        for card in currentlyDisplayedCards {
                            for innerCard in chosenCards {
                                if card.id == innerCard.id {
                                    break;
                                }
                            }
                            cardsToCheck.append(card)
                        }
                        // Get the correct cards from the cards that don't have matches
                        let numberOfMatchesNeeded: Int = (numberOfCardsToWin - numberOfCardsMatched) / 3
                        currentlyDisplayedCards = getCorrectCards(cards: currentlyDisplayedCards, cardsToRemove: chosenCards, numberOfMatchesNeeded: numberOfMatchesNeeded)
                    } else {
                        currentlyDisplayedCards = getCorrectCards(cards: currentlyDisplayedCards, cardsToRemove: chosenCards)
                    }
                }
            } else {
                // They did not make a match :(
                for card in chosenCards {
                    if let index = index(of: card, in: currentlyDisplayedCards) {
                        currentlyDisplayedCards[index].isChosen = false
                        currentlyDisplayedCards[index].isNotAMatch = false
                    }
                }
            }
            
            // Toggle the card they just touched
            if let newActualCardIndex = index(of: card, in: currentlyDisplayedCards) {
                currentlyDisplayedCards[newActualCardIndex].isChosen = !currentlyDisplayedCards[newActualCardIndex].isChosen
            }
        }
    }
    
    func getCorrectCards(cards: [Card], cardsToRemove: [Card], numberOfMatchesNeeded: Int = 1) -> [Card] {
        var cardsToAdd = [getRandomCard(), getRandomCard(), getRandomCard()]
        
        var potentialCards = cards
        for loopIndex in 0...cardsToRemove.count - 1 {
            let cardIndex: Int = index(of: cardsToRemove[loopIndex], in: cards) ?? 0
            potentialCards[cardIndex] = cardsToAdd[loopIndex]
        }
        var cardsToExclude: [Card] = []
        
        // Get the cards that have matches
        cardsToExclude += checkThatAMatchExists(with: potentialCards).cardsWithMatches
        
        
        // Check that the correct number of matches will exist
        var cardToReturnIndex = 0
        while (checkThatAMatchExists(with: potentialCards).numberOfMatches < numberOfMatchesNeeded
               && cardToReturnIndex < 3
        ) {
            var indicesToExclude: [Int] = []
            for card in cardsToExclude {
                if let index = index(of: card, in: cards) {
                    indicesToExclude.append(index)
                }
            }
            
            let randomIndices = getRandomIndices(
                bottomRange: 0,
                topRangeInclusive: potentialCards.count - 1,
                excluding: indicesToExclude
            )
            for index in randomIndices {
                cardsToExclude.append(cards[index])
            }
            
            cardsToAdd[cardToReturnIndex] = createMatch(card1: cards[randomIndices[0]], card2: cards[randomIndices[1]])
            cardToReturnIndex += 1
        }
        
        cardsToAdd = cardsToAdd.shuffled()
        for loopIndex in 0...2 {
            if let index = index(of: cardsToRemove[loopIndex], in: currentlyDisplayedCards) {
                potentialCards[index] = cardsToAdd[loopIndex]
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
    
    func index(of targetCard: Card, in cardsToCheck: [Card]) -> Int? {
        for index in 0 ..< cardsToCheck.count {
            if cardsToCheck[index].id == targetCard.id {
                return index
            }
        }
        return nil
    }
    
    mutating func giveHint() {
        for card in currentlyDisplayedCards {
            if card.isChosen {
                if let index = index(of: card, in: currentlyDisplayedCards) {
                    currentlyDisplayedCards[index].isChosen = false
                }
            }
        }
        // get two cards that have a match
        for card1 in currentlyDisplayedCards {
            for card2 in currentlyDisplayedCards {
                for card3 in currentlyDisplayedCards {
                    var cardArray = [card1, card2, card3]
                    if card1.id != card2.id && card1.id != card3.id && card2.id != card3.id {
                        if (checkIsMatch(with: cardArray)) {
                            cardArray.shuffle()
                            if let index = index(of: cardArray[0], in: currentlyDisplayedCards) {
                                currentlyDisplayedCards[index].isChosen = true
                            }
                            if let index = index(of: cardArray[1], in: currentlyDisplayedCards) {
                                currentlyDisplayedCards[index].isChosen = true
                            }
                            return
                        }
                    }
                }
            }
        }
    }
    
    let numberOfCardsToWin: Int = 18
}

struct CheckThatAMatchExistsReturnType {
    var numberOfMatches: Int
    var cardsWithMatches: [Card]
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
