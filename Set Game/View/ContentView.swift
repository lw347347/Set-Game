//
//  ContentView.swift
//  Set Game
//
//  Created by Landon Williams on 9/17/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var setGameViewModel: SetGameViewModel
    
    @State private var dealtCards = Set<UUID>()
    @Namespace private var dealingCards
    
    var body: some View {
        VStack(alignment: .center) {
            randomDeckOffScreenBody
            gameBody
        }
    }
    var gameBody: some View {
        VStack {
            HStack {
                Button("New Game") {
                    withAnimation {
                        setGameViewModel.createNewGame()
                        dealCards()
                    }
                }
                Button("Deal 3 More Cards") {
                    setGameViewModel.deal3MoreCards()
                }
            }
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(setGameViewModel.cards) { card in
                    if (isDealt(card)) {
                        if card.isChosen {
                            CardView(card: card)
                                .matchedGeometryEffect(id: card.id, in: dealingCards)
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
                                .matchedGeometryEffect(id: card.id, in: dealingCards)
                        }
                    }
                }.aspectRatio(3/2, contentMode: .fit)
            }
        }
    }
    var randomDeckOffScreenBody: some View {
        ZStack {
            ForEach(setGameViewModel.cards) { card in
                if (!isDealt(card)) {
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: dealingCards)
                }
            }
        }.frame(width: 50, height: 50, alignment: .bottom)
    }
    private func dealCards() -> Void {
        dealtCards = Set<UUID>()
        withAnimation(.easeInOut(duration: 3)) {
            for card in setGameViewModel.cards {
                dealtCards.insert(card.id)
            }
        }
    }
    private func isDealt(_ card: Card) -> Bool {
        return dealtCards.contains(card.id)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let setGameViewModel = SetGameViewModel()
        ContentView(setGameViewModel: setGameViewModel)
    }
}
