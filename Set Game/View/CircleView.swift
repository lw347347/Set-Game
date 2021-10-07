//
//  CircleView.swift
//  Set Game
//
//  Created by Landon Williams on 10/6/21.
//

import SwiftUI

struct CircleView: View {
    var color: Color
    var opacity: CGFloat
    var body: some View {
        ZStack {
            Circle().fill(color).opacity(opacity)
                .aspectRatio(1, contentMode: .fit)
            Circle().stroke(color, lineWidth: 4)
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView(color: .green, opacity: 0.5)
    }
}
