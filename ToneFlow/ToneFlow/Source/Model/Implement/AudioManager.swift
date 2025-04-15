import Foundation
import AVFAudio
import Combine

final class AudioManager {
    static let shared = AudioManager(
        audioIOManager: AudioIOManager(),
        audioEngineController: AudioEngineController(),
        isMock: false
    )
    private var cancellables = Set<AnyCancellable>()
    
    var availableInputDevices: CurrentValueSubject<[AudioPortDescription], Never> = .init([]) {
        didSet {
            // Removed logging
        }
    }

    var currentInputDevice: CurrentValueSubject<AudioPortDescription?, Never> = .init(nil)
    var currentOutputDevice: CurrentValueSubject<AudioPortDescription?, Never> = .init(nil)
    
    private let audioIOManager: AudioIOManaging
    private let audioEngineController: AudioEngineControlling

    private init(audioIOManager: AudioIOManaging, audioEngineController: AudioEngineControlling, isMock: Bool) {
        self.audioIOManager = audioIOManager
        self.audioEngineController = isMock ? MockAudioEngineController() : audioEngineController
        self.audioEngineController.setup()
        self.audioEngineController.start()
        updateAvailableInputDevices()
        updateCurrentInputDevice()
        updateCurrentOutputDevice()
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
