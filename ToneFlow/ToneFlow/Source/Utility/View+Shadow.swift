//
//  View+Shadow.swift
//  ToneFlow
//
//  Created by YoungK on 4/3/25.
//

import SwiftUI

public extension View {
    func tfShadow(alpha: Double, blur: CGFloat, x: CGFloat = 4, y: CGFloat = 4) -> some View {
        self.shadow(color: Color.black.opacity(alpha), radius: blur, x: x, y: y)
    }
}
