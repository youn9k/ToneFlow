//
//  EQView.swift
//  ToneFlow
//
//  Created by YoungK on 4/13/25.
//

import SwiftUI

struct EQView: View {
    @Binding var isOn: Bool
    @Binding var hz65Value: Double
    @Binding var hz125Value: Double
    @Binding var hz250Value: Double
    @Binding var khz1Value: Double
    @Binding var khz2Value: Double
    @Binding var khz4Value: Double
    @Binding var khz8Value: Double
    @Binding var khz16Value: Double

    var body: some View {
        GeometryReader { geometry in
            // 피그마 기준 비율로 크기 계산
            let sliderGroupRatio: CGFloat = 185 / 362
            let sliderGroupHeight: CGFloat = geometry.size.height * sliderGroupRatio
            let buttonRatio: CGFloat = 50 / 362
            let buttonSize: CGFloat = geometry.size.width * buttonRatio
            
            ZStack {
                TFRoundedRectangleView()
                
                VStack(spacing: 0) {
                    HStack {
                        sliderGroupView(value: $hz65Value, label: "65 Hz")
                        sliderGroupView(value: $hz125Value, label: "125 Hz")
                        sliderGroupView(value: $hz250Value, label: "250 Hz")
                        sliderGroupView(value: $khz1Value, label: "1 kHz")
                        sliderGroupView(value: $khz2Value, label: "2 kHz")
                        sliderGroupView(value: $khz4Value, label: "4 kHz")
                        sliderGroupView(value: $khz8Value, label: "8 kHz")
                        sliderGroupView(value: $khz16Value, label: "16 kHz")
                    }
                    .frame(height: sliderGroupHeight)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                    
                    // Indicator
                    Circle()
                        .foregroundStyle(isOn ? .POINT_2 : .gray400)
                        .frame(width: 5, height: 5)
                        .padding(.bottom, 10)
                    
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
                }
                .padding(.vertical, 20)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    func sliderGroupView(value: Binding<Double>, label: String) -> some View {
        VStack(spacing: 10) {
            Text(String(format: "%.1f", value.wrappedValue))
                .tfFont(.t7(.medium))
                .foregroundStyle(.gray800)
            SliderView(value: value, trackColor: .gray300, handleColor: .POINT_2)
                .frame(width: 10)
            Text(label)
                .tfFont(.t7(.medium))
                .foregroundStyle(.gray800)
        }
    }
}

#Preview {
    EQView(
        isOn: .constant(false), 
        hz65Value: .constant(0), 
        hz125Value: .constant(0),
        hz250Value: .constant(0),
        khz1Value: .constant(0),
        khz2Value: .constant(0),
        khz4Value: .constant(0), 
        khz8Value: .constant(0),
        khz16Value: .constant(0)
    )
}
