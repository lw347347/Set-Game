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
                        .offset(x: getRandomOffset(), y: getRandomOffset())
                }
            }
        }.frame(width: 50, height: 50, alignment: .bottom)
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
    private func dealCards() -> Void {
        dealtCards = Set<UUID>()
        for card in setGameViewModel.cards {
            dealCard(card)
        }
    }
    private func dealCard(_ card: Card) -> Void {
        withAnimation(.easeInOut(duration:1)) {
            dealtCards.insert(card.id)
        }
    }
    private func undealCard(_ card: Card) -> Void {
        withAnimation(.easeInOut(duration:1)) {
            if let index = dealtCards.firstIndex(of: card.id) {
                dealtCards.remove(at: index)
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
