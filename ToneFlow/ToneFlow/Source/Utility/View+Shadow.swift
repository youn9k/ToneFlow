//
//  View+Shadow.swift
//  ToneFlow
//
//  Created by YoungK on 4/3/25.
//

import SwiftUI

public extension View {
    func shadow(alpha: Double, blur: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        self.shadow(color: Color.black.opacity(alpha), radius: blur, x: x, y: y)
    }
    
    func tfShadow(alpha: Double, blur: CGFloat) -> some View {
        self.shadow(alpha: alpha, blur: blur, x: 4, y: 4)
    }
}
