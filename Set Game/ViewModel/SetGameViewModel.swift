//
//  SetGameViewModel.swift
//  SetGameViewModel
//
//  Created by Landon Williams on 9/17/21.
//

import Foundation

class SetGameViewModel: ObservableObject {
    @Published var setGame: SetGame = createGame()
    
    var cards: [Card] {
        return setGame.currentlyDisplayedCards
    }
    
    public func choose(card: Card) {
        setGame.choose(card: card)
    }
    
    private static func createGame() -> SetGame {
        return SetGame()
    }
}
