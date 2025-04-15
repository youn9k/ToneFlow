//
//  AudioEngineManager.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import AVFAudio

final class AudioEngineManager: AudioEngineManageable {
    private var audioEngine: AVAudioEngine?

    func setup() {
        audioEngine = AVAudioEngine()
        
        guard let audioEngine = audioEngine else { return }
        
        audioEngine.connect(audioEngine.inputNode, to: audioEngine.mainMixerNode, format: nil)
    }

    func start() {
        guard let audioEngine = audioEngine else {
            print("audioEngine is not initialized")
            return
        }
        do {
            try audioEngine.start()
            print("Audio engine started.")
        } catch {
            print("Audio engine start error: \(error.localizedDescription)")
        }
    }
    
    func restart() {
        guard let audioEngine = audioEngine else {
            print("audioEngine is not initialized")
            return
        }
        do {
            audioEngine.stop()
            try audioEngine.start()
            print("Audio engine started.")
        } catch {
            print("Audio engine start error: \(error.localizedDescription)")
        }
    }
}
