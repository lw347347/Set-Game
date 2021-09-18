//
//  SetGameModel.swift
//  SetGameModel
//
//  Created by Landon Williams on 9/17/21.
//

import Foundation
import SwiftUI

struct SetGame {
    var cards: [Card] = []
    
    init() {
        for _ in 0...15 {
            cards.append(Card(numberOfShapes: 3, color: .red, pattern: "Solid"))
        }
    }
}

struct Card: Identifiable {
    let id = UUID()
    let shape: some Shape = Circle()
    let numberOfShapes: Int
    let color: Color
    let pattern: String
}


