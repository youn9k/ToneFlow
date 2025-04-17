import Foundation
import AVFAudio
import Combine

final class AudioEnvrionment {
    static let shared = AudioEnvrionment(
        audioSessionManager: AudioSessionManager(),
        audioEngineManager: MockAudioEngineManager(),
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
    
    var currentInputGain: AnyPublisher<Float, Never> {
        audioSessionManager.currentnputGainPublisher
    }
    
    var currentOutputVolume: AnyPublisher<Float, Never> {
        audioSessionManager.currentOutputVolumePublisher
    }
    
    private init(audioSessionManager: AudioSessionManageable, audioEngineManager: AudioEngineManageable, isMock: Bool) {
        self.audioSessionManager = audioSessionManager
        self.audioEngineManager = audioEngineManager
        self.audioEngineManager.setup()
        self.audioEngineManager.start()
        
        NotificationCenter.default
            .publisher(for: AVAudioSession.routeChangeNotification)
            .sink { [weak self] _ in
                self?.audioEngineManager.restart()
            }
            .store(in: &cancellables)
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
    
    func setInputGain(_ gain: Float) throws {
        try audioSessionManager.setInputGain(gain)
    }
    
    func setOutputVolume(_ volume: Float) {
        audioSessionManager.setOutputVolume(volume)
    }
}
