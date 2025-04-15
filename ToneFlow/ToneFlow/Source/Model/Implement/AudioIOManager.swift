//
//  AudioIOManager.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import AVFAudio
import Combine

final class AudioIOManager: AudioIOManaging {
    private var cancellables = Set<AnyCancellable>()
    private let session = AVAudioSession.sharedInstance()
    
    var availableInputs: [AudioPortDescription] {
        return session.availableInputs?.compactMap { $0 as AudioPortDescription } ?? []
    }
    
    var currentInput: AudioPortDescription? {
        return session.currentRoute.inputs.first as AudioPortDescription?
    }
    
    var currentOutput: AudioPortDescription? {
        return session.currentRoute.outputs.first as AudioPortDescription?
    }
    
    init() {
        setupAudioSession()
        observeRouteChanges()
    }
    
    @discardableResult
    func selectInput(named name: String) -> Bool {
        let availableInputs = self.availableInputs
        
        if let device = availableInputs.first(where: { $0.name == name }) {
            do {
                try session.setPreferredInput(device as? AVAudioSessionPortDescription)
                return true
            } catch {
                print("❌ 입력 장치 변경 실패: \(error.localizedDescription)")
                return false
            }
        } else {
            print("⚠️ 입력 장치를 찾을 수 없음: \(name)")
            return false
        }
    }
    
    func observeRouteChanges() {
        NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification).sink { [weak self] notification in
            guard let self = self else { return }
            // Handle route change
        }
        .store(in: &cancellables)
    }
    
    private func setupAudioSession() {
        try? session.setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers, .allowBluetooth, .allowBluetoothA2DP])
        try? session.setActive(true)
        try? session.setInputGain(0.5)
    }
}
