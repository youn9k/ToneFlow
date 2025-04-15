//
//  MockAudioSessionManager.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import AVFAudio
import Combine

final class MockAudioSessionManager: AudioSessionManageable {
    let availableInputsPublisher: AnyPublisher<[AudioPortDescription], Never>
    
    let currentInputPublisher: AnyPublisher<AudioPortDescription?, Never>
    
    let currentOutputPublisher: AnyPublisher<AudioPortDescription?, Never>
    
    init() {
        availableInputsPublisher = Just([
            MockAudioPortDescription(name: "Mock Input 1", identifier: "1", port: .builtInMic),
            MockAudioPortDescription(name: "Mock Input 2", identifier: "2", port: .bluetoothHFP)
        ]).eraseToAnyPublisher()
        
        currentInputPublisher = Just(MockAudioPortDescription(name: "Mock Input 1", identifier: "1", port: .builtInMic)).eraseToAnyPublisher()
        
        currentOutputPublisher = Just(MockAudioPortDescription(name: "Mock Output 1", identifier: "10", port: .builtInSpeaker)).eraseToAnyPublisher()
    }

}
