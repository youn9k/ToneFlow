import Foundation
import AVFAudio
import Combine

final class AudioEnvrionment {
    static let shared = AudioEnvrionment(
        audioIOManager: AudioIOManager(),
        audioEngineManager: AudioEngineManager(),
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
    private let audioEngineManager: AudioEngineManageable

    private init(audioIOManager: AudioIOManaging, audioEngineManager: AudioEngineManageable, isMock: Bool) {
        self.audioIOManager = audioIOManager
        self.audioEngineManager = isMock ? MockAudioEngineController() : audioEngineManager
        self.audioEngineManager.setup()
        self.audioEngineManager.start()
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
