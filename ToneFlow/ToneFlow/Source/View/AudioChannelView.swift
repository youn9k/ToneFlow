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
    
    @ObservedObject var viewModel: AudioChannelViewModel
    @State private var knobValue: Double = 0.5
    let type: ChannelType

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
            
            // 기기 선택 메뉴
            if type == .input {
                Menu {
                    ForEach(viewModel.availableInputDevices, id: \.self) { device in
                        Button(device) {
                            viewModel.send(.selectInputDevice(device))
                        }
                    }
                } label: {
                    Text(viewModel.currentInputDeviceName)
                        .modifier(deviceSelectButtonModifier)
                }
            } else {
                Text(viewModel.currentOutputDeviceName)
                    .tfFont(.t6(.medium))
                    .bold()
                    .foregroundStyle(.gray800)
                    .lineLimit(1)
                    .padding(.vertical, 10)
            }
        }
        .onChange(of: knobValue) {
            if type == .input {
                viewModel.send(.changedInputKnobValue(knobValue))
            } else {
                viewModel.send(.changedOutputKnobValue(knobValue))
            }
        }
    }
    
    // 볼륨 미터 뷰
    private var volumeMeterView: some View {
        let volumeText = type == .input ? viewModel.inputGainText : viewModel.outputVolumeText
        
        return VStack(spacing: 9) {
            #warning("입출력되는 수치로 변경 예정")
            TFVolumeMeterView(volume: .constant(0.5))
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
            KnobView(knobValue: $knobValue)
                .frame(width: 80, height: 80)
                .tfShadow(alpha: 0.25, blur: 10)
                .padding(.top, 20)
            
            Text(type.title)
                .tfFont(.t4(.medium))
                .foregroundStyle(.gray700)
                .padding(.top, 5)
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        // 입력 채널 미리보기
        AudioChannelView(
            viewModel: AudioChannelViewModel(),
            type: .input
        )
        
        // 출력 채널 미리보기
        AudioChannelView(
            viewModel: AudioChannelViewModel(),
            type: .output
        )
    }
}
