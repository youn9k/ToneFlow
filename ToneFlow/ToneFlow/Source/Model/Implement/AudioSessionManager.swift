//
//  AudioSessionManager.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import AVFAudio
import Combine

final class AudioSessionManager: AudioSessionManageable {
    private var cancellables = Set<AnyCancellable>()
    private let session = AVAudioSession.sharedInstance()
    
    let availableInputsPublisher: AnyPublisher<[AudioPortDescription], Never>
    let currentInputPublisher: AnyPublisher<AudioPortDescription?, Never>
    let currentOutputPublisher: AnyPublisher<AudioPortDescription?, Never>
    
    init() {
        availableInputsPublisher = session.publisher(for: \.availableInputs)
            .map { $0 ?? [] }
            .eraseToAnyPublisher()
        
        currentInputPublisher = session.publisher(for: \.currentRoute)
            .map(\.inputs.first)
            .eraseToAnyPublisher()
        
        currentOutputPublisher = session.publisher(for: \.currentRoute)
            .map(\.outputs.first)
            .eraseToAnyPublisher()
        
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        try? session.setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers, .allowBluetooth, .allowBluetoothA2DP])
        try? session.setActive(true)
        try? session.setInputGain(0.5)
    }
}
