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
        ZStack {
            if (card.isChosen) {
                HStack {
                    ForEach(1...card.numberOfShapes, id: \.self) {_ in
                        shapeBody(card: card).padding()
                    }
                }.border(.green, width: 9)
            } else {
                HStack {
                    ForEach(1...card.numberOfShapes, id: \.self) {_ in
                        shapeBody(card: card)
                    }
                }
            }
        }.padding()
            .aspectRatio(2/3, contentMode: .fit)
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
