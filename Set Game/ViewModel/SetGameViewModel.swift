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
    
    public func toggleChosen(card: Card) {
        print("clicked a card")
        setGame.toggleChosen(card: card)
    }
    
    public func deal3MoreCards() {
        setGame.deal3MoreCards();
    }
    
    private static func createGame() -> SetGame {
        return SetGame()
    }
    
    public func createNewGame() -> Void {
        setGame = SetGameViewModel.createGame()
    }
}
