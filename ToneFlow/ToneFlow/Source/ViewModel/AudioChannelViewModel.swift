//
//  AudioChannelViewModel.swift
//  ToneFlow
//
//  Created by YoungK on 4/14/25.
//

import SwiftUI
import Combine
import AVFoundation

final class AudioChannelViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    private let audioEnvrionment: AudioEnvrionment
    
    // MARK: - Action

    enum Action {
        case selectInputDevice(String)
        case changedInputKnobValue(Double)
        case changedOutputKnobValue(Double)
    }

    // MARK: - State
    
    // 볼륨을 숫자로 표시 ("0 ~ 100")
    @Published var inputGainText: String = ""
    @Published var outputVolumeText: String = ""
    
    // 선택된 장치 이름 ("iPhone 마이크")
    @Published var currentInputDeviceName: String = ""
    @Published var currentOutputDeviceName: String = ""
    
    // 사용 가능한 입력 장치 목록
    @Published var availableInputDevices: [String] = []
    
    init(audioEnvrionment: AudioEnvrionment = AudioEnvrionment.shared) {
        self.audioEnvrionment = audioEnvrionment
        bindState()
    }
    
    func send(_ action: Action) {
        switch action {
        case .selectInputDevice(let deviceName):
            updateInputDevice(deviceName)
        
        case .changedInputKnobValue(let value):
            updateInputGain(value)
        
        case .changedOutputKnobValue(let value):
            updateOutputVolume(value)
        }
    }
    
    private func updateInputDevice(_ name: String) {
        audioEnvrionment.setPreferredInput(name: name)
    }
    
    private func updateInputGain(_ gain: Double) {
        let gain = Float(gain)
        try? audioEnvrionment.setInputGain(gain)
    }
    
    private func updateOutputVolume(_ volume: Double) {
        let volume = Float(volume)
        audioEnvrionment.setOutputVolume(volume)
    }
    
    private func bindState() {
        audioEnvrionment.currentInputDevicePublisher
            .map { $0?.name ?? "알 수 없음" }
            .assign(to: \.currentInputDeviceName, on: self)
            .store(in: &cancellables)
        
        audioEnvrionment.currentOutputDevicePublisher
            .map { $0?.name ?? "알 수 없음" }
            .assign(to: \.currentOutputDeviceName, on: self)
            .store(in: &cancellables)
        
        audioEnvrionment.availableInputDevicesPublisher
            .map { $0.map(\.name) }
            .assign(to: \.availableInputDevices, on: self)
            .store(in: &cancellables)
        
        audioEnvrionment.currentInputGainPublisher
            .map { $0 * 100 }
            .map { String(Int($0)) }
            .assign(to: \.inputGainText, on: self)
            .store(in: &cancellables)
        
        audioEnvrionment.currentOutputVolumePublisher
            .map { $0 * 100 }
            .map { String(Int($0)) }
            .assign(to: \.outputVolumeText, on: self)
            .store(in: &cancellables)
    }
}

