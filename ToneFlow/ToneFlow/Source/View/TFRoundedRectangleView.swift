//
//  TFRoundedRectangleView.swift
//  ToneFlow
//
//  Created by YoungK on 4/4/25.
//

import SwiftUI

struct TFRoundedRectangleView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.ultraThinMaterial)
            .strokeBorder(Color.white, lineWidth: 1)
            .tfShadow(alpha: 0.25, blur: 20)
    }
}

#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        TFRoundedRectangleView()
            .frame(width: 150, height: 200)
    }
}

#Preview {
    ContentView()
}
