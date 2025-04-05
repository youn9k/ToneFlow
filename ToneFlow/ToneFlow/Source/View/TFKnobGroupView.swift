//
//  TFKnobGroupView.swift
//  ToneFlow
//
//  Created by YoungK on 4/5/25.
//

import SwiftUI

struct TFKnobGroupView: View {
    let title: String
    @Binding var knobValue: Double
    let knobSize: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            KnobView(knobValue: $knobValue)
                .knobFill(.POINT)
                .frame(width: knobSize, height: knobSize)
                .tfShadow(alpha: 0.20, blur: 10)
            
            HStack {
                Text("Min")
                Spacer()
                Text("Max")
            }
            .tfFont(.t6(.medium))
            .foregroundStyle(.gray800)
            .frame(width: knobSize)
            
            Text(title)
                .tfFont(.t4(.medium))
                .foregroundColor(.gray800)
                .padding(.top, 10)
        }
    }
}

#Preview {
    TFKnobGroupView(title: "Test", knobValue: .constant(0.5), knobSize: 80)
}
