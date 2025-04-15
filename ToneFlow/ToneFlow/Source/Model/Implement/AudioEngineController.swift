//
//  AudioEngineController.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import AVFAudio

final class AudioEngineController: AudioEngineControlling {
    private var audioEngine: AVAudioEngine?

    func setup() {
        audioEngine = AVAudioEngine()
    }

    func start() {
        guard let engine = audioEngine else { return }
        let format = engine.inputNode.outputFormat(forBus: 0)

        engine.connect(engine.inputNode, to: engine.mainMixerNode, format: format)
        
        do {
            try engine.start()
            print("Audio engine started.")
        } catch {
            print("Audio engine start error: \(error.localizedDescription)")
        }
    }
}
