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

    private let audioManager: AudioManager
    
    // 채널 값 (노브 및 미터 표시에 사용)
    @Published var inputChannelValue: Double = 0.5
    @Published var outputChannelValue: Double = 0.5
    
    // 선택된 디바이스 정보
    @Published var currentInputDeviceName: String = ""
    @Published var currentOutputDeviceName: String = ""
    
    // 사용 가능한 디바이스 목록
    @Published var availableInputDevices: [AVAudioSessionPortDescription] = []
    @Published var availableOutputDevices: [AVAudioSessionPortDescription] = []
    
    init(audioManager: AudioManager = AudioManager.shared) {
        self.audioManager = audioManager
        bindAudioManager()
    }
    
    private func bindAudioManager() {
        audioManager.currentInputDeviceName.sink { [weak self] name in
            self?.currentInputDeviceName = name
        }.store(in: &cancellables)
        
        audioManager.currentOutputDeviceName.sink { [weak self] name in
            self?.currentOutputDeviceName = name
        }.store(in: &cancellables)
        
        audioManager.availableInputDevices.sink { [weak self] devices in
            self?.availableInputDevices = devices
        }.store(in: &cancellables)
        
        audioManager.availableOutputDevices.sink { [weak self] devices in
            self?.availableOutputDevices = devices
        }.store(in: &cancellables)
    }
    
}

