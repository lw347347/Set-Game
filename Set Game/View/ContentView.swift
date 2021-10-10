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
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
            ForEach(setGameViewModel.cards) { card in
                CardView(card: card).onTapGesture(perform: {
                    setGameViewModel.toggleChosen(card: card)
                }).aspectRatio(2/3, contentMode: .fit)
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
