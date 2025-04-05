//
//  InputView.swift
//  ToneFlow
//
//  Created by YoungK on 4/4/25.
//

import SwiftUI

struct InputView: View {
    @Binding var inputVolume: Double
    @Binding var knobValue: Double
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 23) {
                // 볼륨 미터 부분
                VStack(spacing: 9) {
                    TFVolumeMeterView(volume: $inputVolume)
                        .frame(width: 10, height: 100)
                    
                    let volumeValue: Int = Int(inputVolume.rounded() * 100)
                    Text("\(volumeValue)")
                        .tfFont(.t6(.medium))
                        .foregroundStyle(.gray800)
                }
                
                // 노브 부분
                VStack(spacing: 0) {
                    KnobView(knobValue: $knobValue)
                        .frame(width: 80, height: 80)
                        .tfShadow(alpha: 0.25, blur: 10)
                        .padding(.top, 20)
                    
                    Text("Input")
                        .tfFont(.t4(.medium))
                        .foregroundStyle(.gray700)
                        .padding(.top, 5)
                }
            }
            
            Button {
                
            } label: {
                Text("US 1x2 HR")
                    .modifier(deviceSelectButtonModifier)
            }
        }
    }
}

#Preview {
    InputView(
        inputVolume: .constant(0.5),
        knobValue: .constant(0.5)
    )
}
