//
//  MockAudioEngineManager.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import AVFAudio

class MockAudioEngineManager: AudioEngineManageable {
    private var audioEngine: AVAudioEngine?
    private var audioPlayerNode: AVAudioPlayerNode?
    private var audioFile: AVAudioFile?
    
    func setup() {
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        
        guard let audioEngine = audioEngine,
              let audioPlayerNode = audioPlayerNode else {
            return
        }
        
        audioEngine.attach(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: nil)
    }
    
    func start() {
        guard let engine = audioEngine else { return }
        do {
            try engine.start()
            playLoop()
        } catch {
            print("Failed to start engine: \(error.localizedDescription)")
        }
    }

    func restart() {
        audioPlayerNode?.stop()
        audioEngine?.stop()

        do {
            try audioEngine?.start()
            playLoop()
        } catch {
            print("Failed to restart engine: \(error.localizedDescription)")
        }
    }
    
    private func playLoop() {
        guard let player = audioPlayerNode,
              let url = Bundle.main.url(forResource: "CleanGuitarSound", withExtension: "wav") else {
            print("CleanGuitarSound.wav not found.")
            return
        }

        do {
            let audioFile = try AVAudioFile(forReading: url)
            let audioFormat = audioFile.processingFormat
            let audioFrameCount = UInt32(audioFile.length)
            guard let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount) else { return }
            try audioFile.read(into: audioFileBuffer, frameCount: audioFrameCount)
            
            player.play()
            player.scheduleBuffer(audioFileBuffer, at: nil, options: .loops)

        } catch {
            print("Failed to load or play audio file: \(error.localizedDescription)")
        }
    }
}
