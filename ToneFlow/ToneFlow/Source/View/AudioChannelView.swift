//
//  AudioChannelView.swift
//  ToneFlow
//
//  Created by YoungK on 4/14/25.
//

import SwiftUI

struct AudioChannelView: View {
    enum ChannelType {
        case input
        case output
        
        var title: String {
            switch self {
            case .input: return "Input"
            case .output: return "Output"
            }
        }
    }
    
    var type: ChannelType
    
    @Binding var audioChannelValue: Double
    
    // 화면에 표시될 볼륨 값 텍스트
    @State private var volumeText: String = ""
    
    // 기기 선택 버튼 텍스트
    var deviceName: String
    
    var body: some View {
        VStack(spacing: 0) {
            // 미터와 노브를 포함하는 HStack
            HStack(alignment: .bottom, spacing: 20) {
                if type == .input {
                    volumeMeterView
                    knobView
                } else {
                    knobView
                    volumeMeterView
                }
            }
            
            // 기기 선택 버튼
            Button {

            } label: {
                Text(deviceName)
                    .modifier(deviceSelectButtonModifier)
            }
        }
        .onAppear {
            updateVolumeText()
        }
        .onChange(of: audioChannelValue) {
            updateVolumeText()
        }
    }
    
    // 볼륨 미터 뷰
    private var volumeMeterView: some View {
        VStack(spacing: 9) {
            TFVolumeMeterView(volume: $audioChannelValue)
                .frame(width: 10, height: 100)
            
            Text(volumeText)
                .tfFont(.t6(.medium))
                .foregroundStyle(.gray800)
                .frame(width: 30)
                .monospacedDigit()
        }
    }
    
    // 노브 뷰
    private var knobView: some View {
        VStack(spacing: 0) {
            KnobView(knobValue: $audioChannelValue)
                .frame(width: 80, height: 80)
                .tfShadow(alpha: 0.25, blur: 10)
                .padding(.top, 20)
            
            Text(type.title)
                .tfFont(.t4(.medium))
                .foregroundStyle(.gray700)
                .padding(.top, 5)
        }
    }
    
    // 볼륨 텍스트 업데이트
    private func updateVolumeText() {
        let roundedValue = (audioChannelValue * 100).rounded()
        volumeText = String(Int(roundedValue))
    }
}

#Preview {
    VStack(spacing: 30) {
        // 입력 채널 미리보기
        AudioChannelView(
            type: .input,
            audioChannelValue: .constant(0.5),
            deviceName: "US 1x2 HR"
        )
        
        // 출력 채널 미리보기
        AudioChannelView(
            type: .output,
            audioChannelValue: .constant(0.8),
            deviceName: "~~`s AirPod Pro2"
        )
    }
}
