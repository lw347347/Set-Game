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
    let listOfShapes = [
        CustomShape(actualShape: AnyShape(Circle()), shapeString: "Circle"),
        CustomShape(actualShape: AnyShape(Rectangle()), shapeString: "Rectange"),
        CustomShape(actualShape: AnyShape(Circle()), shapeString: "Ellipse")
    ]
    let listOfPatterns = ["Solid", "Blank", "Striped"]
    
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
        
        func helperFunction(card1Value: Attributes, card2Value: Attributes, possibleValues: [Attributes]) -> Attributes {
            if (card1Value == card2Value) {
                return card1Value
            } else {
                var mySet: Set<Int> = []
                mySet.insert(card1.numberOfShapes)
                mySet.insert(card2.numberOfShapes)
                if (mySet.contains(1) && mySet.contains(2)) {
                    newNumberOfShapes = 3
                } else if (mySet.contains(1) && mySet.contains(3)) {
                    newNumberOfShapes = 2
                } else {
                    newNumberOfShapes = 1
                }
            }
            // TODO
            return card1Value
        }
        
        let card1 = cards[randomIndex1]
        let card2 = cards[randomIndex2]
        var newNumberOfShapes: Int
        var newColor: Color
        var newShape: CustomShape
        var newPattern: String
        
        // NumberOfShapes
        
        
        // Color
        
        
        let newCard = Card(shape: newShape, numberOfShapes: newNumberOfShapes, color: newColor, pattern: newPattern)
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
            let myPatternSet: Set<String> = [card1.pattern, card2.pattern, card3.pattern]
            if (myPatternSet.count == 2) {
                return false
            }
            
            // Shape string
            let myShapeStringSet: Set<String> = [card1.shape.shapeString, card2.shape.shapeString, card3.shape.shapeString]
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
            numberOfShapes: Int.random(in: 0...2),
            color: listOfColors[Int.random(in: 0...2)],
            pattern: listOfPatterns[Int.random(in: 0...2)]
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
    let shape: CustomShape
    let numberOfShapes: Int
    let color: Color
    let pattern: String
    var isChosen: Bool = false
    var isMatched: Bool = false
}

struct CustomShape {
    let actualShape: AnyShape
    let shapeString: String
}

enum Attributes {
    case CustomShape
    case Int
    case String
    case Color
}

// Copied from https://forums.swift.org/t/cannot-convert-return-expression-of-type-circle-to-return-type-some-shape/27465/2
// Accessed 30 September 2021
protocol Shape {
    associatedtype S
}
extension Shape {
    typealias S = Self
}

struct Circle: Shape { }
struct Rectangle: Shape {}

struct AnyShape: Shape  {
    init<S: Shape>(_ shape: S) { }
}
