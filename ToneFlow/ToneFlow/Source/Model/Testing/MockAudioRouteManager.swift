//
//  MockAudioRouteManager.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import AVFAudio

final class MockAudioRouteManager: AudioRouteManageable {
    var availableInputs: [AudioPortDescription] {
        return [
            MockAudioPortDescription(name: "Mock Input 1", identifier: "1", port: .builtInMic),
            MockAudioPortDescription(name: "Mock Input 2", identifier: "2", port: .bluetoothHFP)
        ]
    }
    
    var currentInput: AudioPortDescription? {
        return availableInputs.first
    }
    
    var currentOutput: AudioPortDescription? {
        return availableInputs.first
    }
    
    func selectInput(named name: String) -> Bool {
        return availableInputs.contains(where: { $0.name == name })
    }
    
    func observeRouteChanges() {
    }
}
