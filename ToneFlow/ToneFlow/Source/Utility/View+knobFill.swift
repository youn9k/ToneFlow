//
//  View+fill.swift
//  ToneFlow
//
//  Created by YoungK on 4/3/25.
//

import SwiftUI

public struct KnobFillColorKey: EnvironmentKey {
    public static let defaultValue: Color? = nil
}

public extension EnvironmentValues {
    var knobFillColor: Color? {
        get { self[KnobFillColorKey.self] }
        set { self[KnobFillColorKey.self] = newValue }
    }
}

public extension View {
    func knobFill(_ color: Color) -> some View {
        self.environment(\.knobFillColor, color)
    }
}
