//
//  OutputView.swift
//  ToneFlow
//
//  Created by YoungK on 4/4/25.
//

import SwiftUI

struct OutputView: View {
    @Binding var outputVolume: Double
    @Binding var knobValue: Double
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 23) {
                // 노브 부분
                VStack(spacing: 0) {
                    KnobView(knobValue: $knobValue)
                        .frame(width: 80, height: 80)
                        .tfShadow(alpha: 0.25, blur: 10)
                        .padding(.top, 20)
                    
                    Text("Output")
                        .tfFont(.t4(.medium))
                        .foregroundStyle(.gray700)
                        .padding(.top, 5)
                }
                
                // 볼륨 미터 부분
                VStack(spacing: 9) {
                    TFVolumeMeterView(volume: $outputVolume)
                        .frame(width: 10, height: 100)
                    
                    let volumeValue: Int = Int(outputVolume.rounded() * 100)
                    Text("\(volumeValue)")
                        .tfFont(.t6(.medium))
                        .foregroundStyle(.gray800)
                }
            }
            
            Button {
                // 버튼 액션 구현
            } label: {
                Text("~~`s AirPod Pro2")
                    .modifier(deviceSelectButtonModifier)
            }
        }
    }
}

#Preview {
    OutputView(outputVolume: .constant(0.5), knobValue: .constant(0.5))
}
