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
                RoundedRectangle(cornerRadius: 10).fill(.green)
                HStack {
                    ForEach(1...card.numberOfShapes, id: \.self) {_ in
                        RoundedRectangle(cornerRadius: 10).fill(.green)
                    }
                }
                .frame(width: CGFloat(20), height: CGFloat(20), alignment: .center)
            } else {
                RoundedRectangle(cornerRadius: 10).fill(.white)
                HStack {
                    ForEach(1...card.numberOfShapes, id: \.self) {_ in
                        RoundedRectangle(cornerRadius: 10).fill(.green)
                    }
                }
                .border(Color.gray)
                .frame(width: CGFloat(20), height: CGFloat(20), alignment: .center)
            }
            
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(shape: "Circle", numberOfShapes: 3, color: Color.red, opacity: 0.5))
    }
}

@ViewBuilder
private func shapeBody(shape: String) -> some View {
    if (shape == "Circle") {
        ZStack {
            Circle()
        }
    } else if (shape == "Squigly") {
        RoundedRectangle(cornerRadius: 10)
    } else {
        Image("hello")
    }
}
