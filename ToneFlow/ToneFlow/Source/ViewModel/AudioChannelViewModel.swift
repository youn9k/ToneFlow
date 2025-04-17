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
        bindAction()
    }
    
    func updateInputDevice(withName name: String) {
        audioEnvrionment.setPreferredInput(name: name)
    }
    
    func setInputGain(_ gain: Float) {
        try? audioEnvrionment.setInputGain(gain)
    }
    
    func setOutputVolume(_ volume: Float) {
        audioEnvrionment.setOutputVolume(volume)
    }
    
    private func bindAction() {
        $inputChannelValue.map { Float($0) }.sink { [weak self] value in
            self?.setInputGain(value)
        }.store(in: &cancellables)
        
        $outputChannelValue.map { Float($0) }.sink { [weak self] value in
            self?.setOutputVolume(value)
        }.store(in: &cancellables)
    }
    
    private func bindAudioEnvrionment() {
        audioEnvrionment.currentInputDevicePublisher.sink { [weak self] device in
            self?.currentInputDeviceName = device.map(\.name) ?? "알 수 없음"
        }.store(in: &cancellables)
        
        audioEnvrionment.currentOutputDevicePublisher.sink { [weak self] device in
            self?.currentOutputDeviceName = device.map(\.name) ?? "알 수 없음"
        }.store(in: &cancellables)
        
        audioEnvrionment.availableInputDevicesPublisher.sink { [weak self] devices in
            self?.availableInputDevices = devices.map(\.name)
        }.store(in: &cancellables)
    }
}

