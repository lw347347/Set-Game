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
        return setGame.cards
    }
    
    private static func createGame() -> SetGame {
        return SetGame()
    }
}
