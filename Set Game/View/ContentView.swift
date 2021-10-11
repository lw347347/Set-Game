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
        VStack(alignment: .center) {
            gameBody
        }
    }
    var gameBody: some View {
        VStack {
            HStack {
                Button("New Game") {
                    withAnimation {
                        setGameViewModel.createNewGame()
                    }
                }
                Button("Deal 3 More Cards") {
                    withAnimation {
                        setGameViewModel.deal3MoreCards()                        
                    }
                }
            }
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(setGameViewModel.cards) { card in
                    ZStack {
                        if card.isChosen {
                            CardView(card: card)
                                .onTapGesture(perform: {
                                    withAnimation {
                                        setGameViewModel.toggleChosen(card: card)
                                    }
                                })
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.cyan, lineWidth: 4)
                                )
                        } else {
                            CardView(card: card).onTapGesture(perform: {
                                withAnimation {
                                    setGameViewModel.toggleChosen(card: card)
                                }
                            })
                        }
                    }
                    .transition(.offset(x: getRandomOffset(), y: getRandomOffset()))
                }.aspectRatio(3/2, contentMode: .fit)
            }
        }
    }
    private func getRandomOffset() -> CGFloat {
        var valueToReturn: Int
        if Int.random(in: 0...1) == 1 {
            valueToReturn = Int.random(in: 1000...2000)
        } else {
            valueToReturn = Int.random(in: -2000 ... -1000)
        }
        return CGFloat(valueToReturn)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let setGameViewModel = SetGameViewModel()
        ContentView(setGameViewModel: setGameViewModel)
    }
}
