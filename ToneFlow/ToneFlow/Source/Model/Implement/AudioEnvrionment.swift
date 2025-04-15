import Foundation
import AVFAudio
import Combine

final class AudioEnvrionment {
    static let shared = AudioEnvrionment(
        audioSessionManager: AudioSessionManager(),
        audioEngineManager: AudioEngineManager(),
        isMock: false
    )
    private var cancellables = Set<AnyCancellable>()
    private let session = AVAudioSession.sharedInstance()
    
    private let audioSessionManager: AudioSessionManageable
    private let audioEngineManager: AudioEngineManageable
    
    var availableInputDevicesPublisher: AnyPublisher<[AudioPortDescription], Never> {
        audioSessionManager.availableInputsPublisher
    }
    var currentInputDevicePublisher: AnyPublisher<AudioPortDescription?, Never> {
        audioSessionManager.currentInputPublisher
    }
    var currentOutputDevicePublisher: AnyPublisher<AudioPortDescription?, Never> {
        audioSessionManager.currentOutputPublisher
    }
    
    private init(audioSessionManager: AudioSessionManageable, audioEngineManager: AudioEngineManageable, isMock: Bool) {
        self.audioSessionManager = audioSessionManager
        self.audioEngineManager = audioEngineManager
        self.audioEngineManager.setup()
        self.audioEngineManager.start()
    }

    @discardableResult
    func setPreferredInput(name: String) -> Bool {
        if let device = session.availableInputs?.first(where: { $0.name == name }) {
            do {
                try session.setPreferredInput(device)
                return true
            } catch {
                print("error for selecting input device: \(error.localizedDescription)")
                return false
            }
        } else {
            print("error for selecting input device, no device found with name : \(name)")
            return false
        }
    }
}
