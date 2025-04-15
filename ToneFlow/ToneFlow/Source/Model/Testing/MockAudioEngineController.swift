//
//  MockAudioEngineController.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import AVFAudio

class MockAudioEngineController: AudioEngineControlling {
    private var audioEngine: AVAudioEngine?
    private var audioPlayerNode: AVAudioPlayerNode?
    private var audioFile: AVAudioFile?

    func setup() {
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
    }

    func start() {
        guard let audioFileURL = Bundle.main.url(forResource: "CleanGuitarLoop", withExtension: "wav") else {
            print("Audio file not found.")
            return
        }
        
        do {
            audioFile = try AVAudioFile(forReading: audioFileURL)
            audioEngine?.attach(audioPlayerNode!)
            audioEngine?.connect(audioPlayerNode!, to: audioEngine!.mainMixerNode, format: audioFile?.processingFormat)
            audioPlayerNode?.scheduleFile(audioFile!, at: nil, completionHandler: nil)
            try audioEngine?.start()
            audioPlayerNode?.play()
        } catch {
            print("audio engine setting error: \(error.localizedDescription)")
        }
    }
}
