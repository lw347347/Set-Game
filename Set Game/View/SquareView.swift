//
//  SquareView.swift
//  Set Game
//
//  Created by Landon Williams on 10/6/21.
//

import SwiftUI

struct SquareView: View {
    var color: Color
    var opacity: CGFloat
    var body: some View {
        ZStack {
            Rectangle().fill(color).opacity(opacity)
                .aspectRatio(1, contentMode: .fit)
            Rectangle().stroke(color, lineWidth: 4)
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct SquareView_Previews: PreviewProvider {
    static var previews: some View {
        SquareView(color: .red, opacity: 1)
    }
}
