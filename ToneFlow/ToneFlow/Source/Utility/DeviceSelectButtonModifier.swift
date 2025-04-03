//
//  DeviceSelectButtonModifier.swift
//  ToneFlow
//
//  Created by YoungK on 4/3/25.
//

import SwiftUI

public struct DeviceSelectButtonModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .tfFont(.t6(.medium))
            .bold()
            .foregroundStyle(.POINT_2)
            .lineLimit(1)
            .underline(true)
            .padding(.vertical, 10)
    }
}

public let deviceSelectButtonModifier = DeviceSelectButtonModifier()
