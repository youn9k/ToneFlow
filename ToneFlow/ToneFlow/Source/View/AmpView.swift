//
//  AmpView.swift
//  ToneFlow
//
//  Created by YoungK on 4/4/25.
//

import SwiftUI

struct AmpView: View {
    @Binding var isOn: Bool
    @Binding var bassKnobValue: Double
    @Binding var midKnobValue: Double
    @Binding var trebleKnobValue: Double

    var body: some View {
        GeometryReader { geometry in
            // 피그마 기준 비율로 노브 크기 계산 (전체 너비에 비례)
            let knobRatio: CGFloat = 80 / 362
            let knobSize: CGFloat = geometry.size.width * knobRatio
            let buttonSize: CGFloat = knobSize / 2
            
            ZStack {
                TFRoundedRectangleView()
                    .overlay(alignment: .bottomTrailing) {
                        let gradientColor: LinearGradient = LinearGradient(
                            colors: [.sub3, .sub2, .sub1],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        Text("ToneFlow")
                            .tfFont(.t6(.medium))
                            .foregroundStyle(gradientColor)
                            .padding(20)
                    }
                
                VStack(spacing: 0) {
                    // 3개의 노브 그룹
                    HStack(spacing: 30) {
                        TFKnobGroupView(
                            title: "Bass",
                            knobValue: $bassKnobValue,
                            knobSize: knobSize
                        )
                        TFKnobGroupView(
                            title: "Mid",
                            knobValue: $midKnobValue,
                            knobSize: knobSize
                        )
                        TFKnobGroupView(
                            title: "Treble",
                            knobValue: $trebleKnobValue,
                            knobSize: knobSize
                        )
                    }
                    
                    // Indicator
                    Circle()
                        .foregroundStyle(isOn ? .POINT_2 : .gray400)
                        .frame(width: 5, height: 5)
                        .padding(.top, 10)
                    
                    // On/Off 버튼
                    Button {
                        isOn.toggle()
                    } label: {
                        Circle()
                            .fill(.white)
                            .strokeBorder(.gray200, lineWidth: 3)
                            .frame(width: buttonSize, height: buttonSize)
                            .tfShadow(alpha: 0.25, blur: 20)
                    }
                    .padding(.top, 14)
                }
                .padding(.vertical, 20)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    AmpView(isOn: .constant(true), bassKnobValue: .constant(0.5), midKnobValue: .constant(0.5), trebleKnobValue: .constant(0.5))
        .frame(height: 230)
}
