//
//  CardView.swift
//  CardView
//
//  Created by Landon Williams on 9/17/21.
//

import SwiftUI

struct CardView: View {
    var card: Card
    
    var body: some View {
        if (card.isChosen) {
            if (card.isMatched) {
                Text("✅")
            } else {
                HStack {
                    ForEach(1...card.numberOfShapes, id: \.self) {_ in
                        shapeBody(card: card)
                    }
                }.shadow(radius: 10)
            }
            
        } else {
            HStack {
                ForEach(1...card.numberOfShapes, id: \.self) {_ in
                    shapeBody(card: card)
                }
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            CardView(card: Card(shape: "Squiggle", numberOfShapes: 3, color: Color.red, opacity: 0.5, isChosen: true))
                .previewInterfaceOrientation(.portrait)
        } else {
            // Fallback on earlier versions
        }
    }
}

@ViewBuilder
private func shapeBody(card: Card) -> some View {
    if (card.shape == "Circle") {
        CircleView(color: card.color, opacity: card.opacity)
    } else if (card.shape == "Square") {
        SquareView(color: card.color, opacity: card.opacity)
    } else {
        SquiggleView(color: card.color, opacity: card.opacity)
    }
}
