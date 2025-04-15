//
//  AudioChannelViewModel.swift
//  ToneFlow
//
//  Created by YoungK on 4/14/25.
//

import SwiftUI
import Combine
import AVFoundation

class AudioChannelViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    private let audioEnvrionment: AudioEnvrionment
    
    // 채널 값 (노브 및 미터 표시에 사용)
    @Published var inputChannelValue: Double = 0.5
    @Published var outputChannelValue: Double = 0.5
    
    // 선택된 디바이스 정보
    @Published var currentInputDeviceName: String = ""
    @Published var currentOutputDeviceName: String = ""
    
    // 사용 가능한 입력 장치 목록
    @Published var availableInputDevices: [String] = []
    
    init(audioEnvrionment: AudioEnvrionment = AudioEnvrionment.shared) {
        self.audioEnvrionment = audioEnvrionment
        bindAudioEnvrionment()
    }
    
    func updateInputDevice(withName name: String) {
//        audioContext.selectInputDevice(withName: name)
    }
    
    private func bindAudioEnvrionment() {
        audioEnvrionment.currentInputDevice.sink { [weak self] device in
            self?.currentInputDeviceName = device.map(\.name) ?? "알 수 없음"
        }.store(in: &cancellables)
        
        audioEnvrionment.currentOutputDevice.sink { [weak self] device in
            self?.currentOutputDeviceName = device.map(\.name) ?? "알 수 없음"
        }.store(in: &cancellables)
        
        audioEnvrionment.availableInputDevices.sink { [weak self] devices in
            self?.availableInputDevices = devices.map(\.name)
        }.store(in: &cancellables)
    }
}

