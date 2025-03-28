import Foundation
import AVFoundation

final class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    @Published var isRecording: Bool = false
    
    private let session = AVAudioSession.sharedInstance()
    private let engine = AVAudioEngine()
    private let reverb = AVAudioUnitReverb()

    private var audioFile: AVAudioFile?
    private let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("output.caf")

    private var audioPlayer: AVAudioPlayer?

    private init() {
        setupAudioSession()
        setupAudioChain()
    }

    func setReverbMix(_ value: Float) {
        reverb.wetDryMix = value
    }
    
    // MARK: - Audio Setup

    private func setupAudioSession() {
        try? session.setCategory(.playAndRecord, mode: .videoRecording, options: [.defaultToSpeaker, .mixWithOthers])
        try? session.setActive(true)
        try? session.setInputGain(0.5)
    }
    
    private func setupAudioChain() {
        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)

        reverb.loadFactoryPreset(.largeHall)
        reverb.wetDryMix = 50

        engine.attach(reverb)
        engine.connect(input, to: reverb, format: format)
        engine.connect(reverb, to: engine.mainMixerNode, format: format)
    }

    // MARK: - Recording
    func startRecording() {
        startEngine()

        let format = engine.mainMixerNode.outputFormat(forBus: 0)

        do {
            audioFile = try AVAudioFile(forWriting: outputURL, settings: format.settings)
        } catch {
            print("❌ Failed to create output file: \(error)")
        }
        
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self = self, let file = self.audioFile else { return }
            do {
                try file.write(from: buffer)
            } catch {
                print("❌ Failed to write buffer: \(error)")
            }
        }

        print("🎙️ Recording started...")
        isRecording = true
    }

    func stopRecording() {
        try? session.setActive(false)
        engine.mainMixerNode.removeTap(onBus: 0)
        engine.stop()
        print("✅ Recording stopped and engine stopped.")
        print("📁 File saved at: \(outputURL.path)")
        isRecording = false
    }
    
    private func prepareOutputFile() {
        let format = engine.mainMixerNode.outputFormat(forBus: 0)
        do {
            audioFile = try AVAudioFile(forWriting: outputURL, settings: format.settings)
        } catch {
            print("❌ Failed to create output file: \(error)")
        }
    }

    // MARK: - Engine Control
    
    private func startEngine() {
        if !engine.isRunning {
            do {
                try engine.start()
                print("🔊 Audio engine started.")
            } catch {
                print("❌ Failed to start audio engine: \(error)")
                return
            }
        }
    }
    
    // MARK: - Playback

    func playRecording() {
        do {
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: outputURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("▶️ Playback started...")
        } catch {
            print("❌ Failed to play recording: \(error)")
        }
    }

    func stopPlayback() {
        audioPlayer?.stop()
        try? session.setActive(false)
        print("⏹️ Playback stopped.")
    }
}
