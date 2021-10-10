//
//  ContentView.swift
//  Set Game
//
//  Created by Landon Williams on 9/17/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var setGameViewModel: SetGameViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button("New Game") {
                    setGameViewModel.createNewGame()
                }
                Button("Deal 3 More Cards") {
                    setGameViewModel.deal3MoreCards()
                }
            }
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(setGameViewModel.cards) { card in
                    if card.isChosen {
                        CardView(card: card).onTapGesture(perform: {
                            setGameViewModel.toggleChosen(card: card)
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cyan, lineWidth: 4)
                        )
                    } else {                        
                        CardView(card: card).onTapGesture(perform: {
                            setGameViewModel.toggleChosen(card: card)
                        })
                    }
                }.aspectRatio(3/2, contentMode: .fit)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let setGameViewModel = SetGameViewModel()
        ContentView(setGameViewModel: setGameViewModel)
    }
}
