import Foundation
import AVFAudio
import Combine

final class AudioManager {
    static let shared = AudioManager(audioIOManager: AudioIOManager(), isMock: false)
    private var cancellables = Set<AnyCancellable>()
    
    var availableInputDevices: CurrentValueSubject<[AudioPortDescription], Never> = .init([]) {
        didSet {
            // Removed logging
        }
    }

    var currentInputDevice: CurrentValueSubject<AudioPortDescription?, Never> = .init(nil)
    var currentOutputDevice: CurrentValueSubject<AudioPortDescription?, Never> = .init(nil)
    
    private let audioIOManager: AudioIOManaging
    private var audioEngine: AVAudioEngine?
    private var audioPlayerNode: AVAudioPlayerNode?
    private var audioFile: AVAudioFile?

    private init(audioIOManager: AudioIOManaging, isMock: Bool) {
        self.audioIOManager = audioIOManager
        if isMock {
            setupAudioEngine()
        }
        updateAvailableInputDevices()
        updateCurrentInputDevice()
        updateCurrentOutputDevice()
    }

    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        
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

    private func updateAvailableInputDevices() {
        availableInputDevices.send(audioIOManager.availableInputs)
    }

    private func updateCurrentInputDevice() {
        currentInputDevice.send(audioIOManager.currentInput)
    }

    private func updateCurrentOutputDevice() {
        currentOutputDevice.send(audioIOManager.currentOutput)
    }
}
