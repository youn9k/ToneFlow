import AVFAudio
import Combine

final class AudioSessionManager: AudioSessionManageable {
    private var cancellables = Set<AnyCancellable>()
    private let session = AVAudioSession.sharedInstance()
    private let systemVolumeController = SystemVolumeController()
    
    var availableInputsPublisher: AnyPublisher<[AudioPortDescription], Never> {
        routeChangePublisher
            .map { _ in AVAudioSession.sharedInstance().availableInputs ?? [] }
            .eraseToAnyPublisher()
    }
    
    var currentInputPublisher: AnyPublisher<AudioPortDescription?, Never> {
        routeChangePublisher
            .map { _ in AVAudioSession.sharedInstance().currentRoute.inputs.first }
            .eraseToAnyPublisher()
    }
    
    var currentOutputPublisher: AnyPublisher<AudioPortDescription?, Never> {
        routeChangePublisher
            .map { _ in AVAudioSession.sharedInstance().currentRoute.outputs.first }
            .eraseToAnyPublisher()
    }
    
    var currentInputGainPublisher: AnyPublisher<Float, Never> {
        AVAudioSession.sharedInstance().publisher(for: \.inputGain).eraseToAnyPublisher()
    }
    
    var currentOutputVolumePublisher: AnyPublisher<Float, Never> {
        AVAudioSession.sharedInstance().publisher(for: \.outputVolume).eraseToAnyPublisher()
    }
    
    init() {
        setupAudioSession()
    }
    
    private let routeChangePublisher = NotificationCenter.default
        .publisher(for: AVAudioSession.routeChangeNotification)
        .share() // 퍼블리셔 공유

    private func setupAudioSession() {
        try? session.setCategory(.playAndRecord, mode: .default, options: [
            .mixWithOthers,
            .allowBluetooth,
            .allowBluetoothA2DP
        ])
        try? session.setActive(true)
        try? session.setInputGain(0.5)
    }
    
    func setInputGain(_ gain: Float) throws {
        try session.setInputGain(gain)
    }
    
    func setOutputVolume(_ volume: Float) {
        systemVolumeController.setVolume(volume)
    }
}
