import Foundation
import AVFAudio
import Combine

final class AudioEnvrionment {
    static let shared = AudioEnvrionment(
        audioRouteManager: AudioRouteManager(),
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
    
    private let audioRouteManager: AudioRouteManageable
    private let audioEngineManager: AudioEngineManageable

    private init(audioRouteManager: AudioRouteManageable, audioEngineManager: AudioEngineManageable, isMock: Bool) {
        self.audioRouteManager = audioRouteManager
        self.audioEngineManager = isMock ? MockAudioEngineController() : audioEngineManager
        self.audioEngineManager.setup()
        self.audioEngineManager.start()
        updateAvailableInputDevices()
        updateCurrentInputDevice()
        updateCurrentOutputDevice()
    }

    private func updateAvailableInputDevices() {
        availableInputDevices.send(audioRouteManager.availableInputs)
    }

    private func updateCurrentInputDevice() {
        currentInputDevice.send(audioRouteManager.currentInput)
    }

    private func updateCurrentOutputDevice() {
        currentOutputDevice.send(audioRouteManager.currentOutput)
    }
}
