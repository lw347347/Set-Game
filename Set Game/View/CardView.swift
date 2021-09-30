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
                        card.shape
                            .frame(width: CGFloat(20), height: CGFloat(20), alignment: .center)
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: 10).fill(.white)
                HStack {
                    ForEach(1...card.numberOfShapes, id: \.self) {_ in
                        card.shape
                            .frame(width: CGFloat(20), height: CGFloat(20), alignment: .center)
                    }
                }.border(Color.gray)
            }
            
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(numberOfShapes: 3, color: .red, pattern: "Solid", shapeString: "Circle"))
    }
}
