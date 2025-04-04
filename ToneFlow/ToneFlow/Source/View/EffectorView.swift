//
//  EffectorView.swift
//  ToneFlow
//
//  Created by YoungK on 4/3/25.
//

import SwiftUI

struct EffectorView: View {
    @Binding var isOn: Bool
    @Binding var knobValue: Double
    
    let title: String
    
    init(title: String, isOn: Binding<Bool>, knobValue: Binding<Double>) {
        self.title = title
        self._isOn = isOn
        self._knobValue = knobValue
    }
    
    var body: some View {
        GeometryReader { geometry in
            let knobRatio: CGFloat = 100 / 171 // 피그마 기준
            let knobSize: CGFloat = geometry.size.width * knobRatio
            let buttonSize: CGFloat = knobSize / 2
            
            ZStack {
                TFRoundedRectangleView()
                
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
                        .padding(.top, 12)
                        .padding(.bottom, 10)
                    
                    Circle()
                        .foregroundStyle(isOn ? .POINT_2 : .gray400)
                        .frame(width: 5, height: 5)
                        .padding(.bottom, 10)
                    
                    Button {
                        isOn.toggle()
                    } label: {
                        Circle()
                            .fill(.white)
                            .strokeBorder(.gray200, lineWidth: 3)
                            .frame(width: buttonSize, height: buttonSize)
                            .tfShadow(alpha: 0.25, blur: 20)
                    }
                }
                .padding(.vertical, 10)
                
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
        }
        
    }
}

#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        ScrollView {
            VStack {
                EffectorView(title: "Compressor", isOn: .constant(true), knobValue: .constant(0.5))
                    .frame(width: 100, height: 220)

                EffectorView(title: "Compressor", isOn: .constant(true), knobValue: .constant(0.5))
                    .frame(width: 150, height: 220)

                EffectorView(title: "Compressor", isOn: .constant(true), knobValue: .constant(0.5))
                    .frame(width: 171, height: 257)
                    .padding(.bottom, 70)
                
                EffectorView(title: "Compressor", isOn: .constant(true), knobValue: .constant(0.5))
                    .frame(width: 300, height: 220)
                    .padding(.bottom, 70)
            }
        }
        .scrollIndicators(.never)
        .scrollClipDisabled()
    }
}
