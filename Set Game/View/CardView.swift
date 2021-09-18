//
//  CardView.swift
//  CardView
//
//  Created by Landon Williams on 9/17/21.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
        GeometryReader {_ in
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.white)
                HStack {
                    ForEach(1...card.numberOfShapes, id: \.self) {_ in
                        card.shape
                    }
                }
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(numberOfShapes: 3, color: .red, pattern: "Solid"))
    }
}
