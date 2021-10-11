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
        GeometryReader { geometry in
            if card.numberOfShapes == 0 {
                // Empty view
                ZStack {}
            } else {
                ZStack {
                    if (card.isChosen) {
                        if (card.isMatched) {
                            ZStack {
                                HStack {
                                    ForEach(1...card.numberOfShapes, id: \.self) {_ in
                                        shapeBody(card: card)
                                    }
                                }
                                Text("✅")
                            }
                        } else if (card.isNotAMatch) {
                            ZStack {
                                HStack {
                                    ForEach(1...card.numberOfShapes, id: \.self) {_ in
                                        shapeBody(card: card)
                                    }
                                }
                                Text("❗️")
                            }
                        } else {
                            HStack {
                                ForEach(1...card.numberOfShapes, id: \.self) {_ in
                                    shapeBody(card: card)
                                }
                            }
                        }
                        
                    } else {
                        HStack {
                            ForEach(1...card.numberOfShapes, id: \.self) {_ in
                                shapeBody(card: card)
                            }
                        }
                    }
                }.position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
            }            
        }.padding(5)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            CardView(card: Card(shape: "Squiggle", numberOfShapes: 1, color: Color.red, opacity: 0.5, isChosen: true, isMatched: true))
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
