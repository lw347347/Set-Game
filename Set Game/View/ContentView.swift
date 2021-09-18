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
        ForEach(setGameViewModel.cards) { card in
            CardView(card: card)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGameViewModel: SetGameViewModel())
    }
}
