import Foundation
import AVFoundation
import Combine

final class AudioManager {
    static let shared = AudioManager()
    private var cancellables = Set<AnyCancellable>()
        
    // 사용 가능한 디바이스 목록
    var availableInputDevices: CurrentValueSubject<[AVAudioSessionPortDescription], Never> = .init([]) {
        didSet {
            #if DEBUG
            print("availableInputDevices: \(availableInputDevices)")
            #endif
        }
    }
    var availableOutputDevices: CurrentValueSubject<[AVAudioSessionPortDescription], Never> = .init([]) {
        didSet {
            #if DEBUG
            print("availableOutputDevices: \(availableOutputDevices)")
            #endif
        }
    }
    
    // 선택된 디바이스 정보
    var currentInputDeviceName: CurrentValueSubject<String, Never> = .init("")
    var currentOutputDeviceName: CurrentValueSubject<String, Never> = .init("")
    
    private let session = AVAudioSession.sharedInstance()
    private let engine = AVAudioEngine()
    private let reverb = AVAudioUnitReverb()

    private var audioPlayer: AVAudioPlayer?

    private init() {
        setupAudioSession()
        setupAudioChain()
        observeAudioSessionRouteChange()
        //startEngine()
    }
    
    // MARK: - 오디오 장치 선택

    /// 이름으로 입력 장치 선택
    /// - Parameter name: 선택할 입력 장치 이름
    /// - Returns: 성공 여부
    @discardableResult
    func selectInputDevice(withName name: String) -> Bool {
        // 장치 목록 갱신
        updateAvailableInputDevices()
        
        // 이름으로 장치 찾기
        if let device = availableInputDevices.value.first(where: { $0.portName == name }) {
            return selectInputDevice(device)
        } else {
            print("⚠️ 입력 장치를 찾을 수 없음: \(name)")
            return false
        }
    }
    
    /// 입력 장치를 선택합니다
    /// - Parameter device: 선택할 입력 장치 (AVAudioSessionPortDescription)
    /// - Returns: 성공 여부
    @discardableResult
    private func selectInputDevice(_ device: AVAudioSessionPortDescription) -> Bool {
        do {
            try session.setPreferredInput(device)
            currentInputDeviceName.send(device.portName)
            print("📥 입력 장치가 \(device.portName)로 변경되었습니다.")
            return true
        } catch {
            print("❌ 입력 장치 변경 실패: \(error.localizedDescription)")
            return false
        }
    }

    
    // MARK: - Audio Effect
    
    func setReverbMix(_ value: Float) {
        reverb.wetDryMix = value
    }
    
    // MARK: - Observe Notification
    
    private func observeAudioSessionRouteChange() {
        NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification).sink { [weak self] notification in
            guard let self else { return }
            
            self.updateCurrentInputDevice()
            self.updateCurrentOutputDevice()
            
            guard let userInfo = notification.userInfo,
                  let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                  let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
                return
            }
            print("라우팅 변경: \(reason)")
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Update State
    
    /// 사용 가능한 입력 장치 목록을 업데이트합니다.
    private func updateAvailableInputDevices() {
        let discovered = session.availableInputs ?? []
        availableInputDevices.send(discovered)
    }
    
    private func updateCurrentInputDevice() {
        let currentInputDevice = session.currentRoute.inputs.first
        currentInputDeviceName.send(currentInputDevice?.portName ?? "알 수 없음")
    }
    
    private func updateCurrentOutputDevice() {
        let currentOutputDevice = session.currentRoute.outputs.first
        currentOutputDeviceName.send(currentOutputDevice?.portName ?? "알 수 없음")
    }
    
    // MARK: - Audio Setup

    private func setupAudioSession() {
        try? session.setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers, .allowBluetooth, .allowBluetoothA2DP])
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
}
