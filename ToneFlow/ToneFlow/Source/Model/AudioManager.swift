import Foundation
import AVFoundation
import Combine

final class AudioManager {
    static let shared = AudioManager()
    private var cancellables = Set<AnyCancellable>()
        
    // 사용 가능한 입력 장치 목록
    var availableInputDevices: CurrentValueSubject<[AVAudioSessionPortDescription], Never> = .init([]) {
        didSet {
            logAvailableAudioDevices()
        }
    }

    // 선택된 디바이스 정보
    var currentInputDevice: CurrentValueSubject<AVAudioSessionPortDescription?, Never> = .init(nil)
    var currentOutputDevice: CurrentValueSubject<AVAudioSessionPortDescription?, Never> = .init(nil)
    
    private let session = AVAudioSession.sharedInstance()
    private let engine = AVAudioEngine()
    private let reverb = AVAudioUnitReverb()

    private init() {
        setupAudioSession()
        setupAudioChain()
        startEngine()
        
        // 사용 가능한 입력 장치 목록 업데이트
        updateAvailableInputDevices()
        
        // 초기 입, 출력 장치 설정(첫번째 장치로)
        updateCurrentInputDevice()
        updateCurrentOutputDevice()
        
        observeAudioSessionRouteChange()
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
            currentInputDevice.send(device)
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
            
            self.updateAvailableInputDevices()
            self.updateCurrentOutputDevice()
            
            self.startEngine()
            
            guard let userInfo = notification.userInfo,
                  let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                  let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
                return
            }
            
            switch reason {
            case .newDeviceAvailable:
                print("새로운 입력 장치가 발견됨")
            case .oldDeviceUnavailable:
                print("이전 입력 장치가 사라짐")
            default:
                print("라우팅 변경: \(reason)")
            }
            
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
        self.currentInputDevice.send(currentInputDevice)
    }
    
    private func updateCurrentOutputDevice() {
        let currentOutputDevice = session.currentRoute.outputs.first
        self.currentOutputDevice.send(currentOutputDevice)
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

        //engine.attach(reverb)
        //engine.connect(input, to: reverb, format: format)
        //engine.connect(reverb, to: engine.mainMixerNode, format: format)
        
        engine.connect(engine.inputNode, to: engine.mainMixerNode, format: format)
    }

    // MARK: - Engine Control
    
    private func startEngine() {
        if !engine.isRunning {
            do {
                if engine.isRunning {
                    engine.stop()
                    try engine.start()
                } else {
                    try engine.start()
                }
                print("🔊 Audio engine started.")
            } catch {
                print("❌ Failed to start audio engine: \(error)")
                return
            }
        }
    }
    
    // MARK: - Logging
    
    /// 현재 사용 가능한 모든 오디오 장치를 로깅합니다.
    private func logAvailableAudioDevices() {
        // 사용 가능한 입력 장치 목록
        print("===== 사용 가능한 입력 장치 목록 =====")
        if let availableInputs = session.availableInputs, !availableInputs.isEmpty {
            for (index, input) in availableInputs.enumerated() {
                print("\(index + 1). 이름: \(input.portName), 타입: \(input.portType)")
                
                // 데이터 소스 정보 (있는 경우)
                if let dataSources = input.dataSources, !dataSources.isEmpty {
                    print("   데이터 소스:")
                    for (dsIndex, dataSource) in dataSources.enumerated() {
                        print("   \(dsIndex + 1). \(dataSource.dataSourceName), ID: \(dataSource.dataSourceID)")
                    }
                }
            }
        } else {
            print("사용 가능한 입력 장치가 없습니다.")
        }
        
        // 현재 라우트 정보
        print("\n===== 현재 오디오 라우트 =====")
        let route = session.currentRoute
        
        print("현재 입력 장치:")
        for (index, input) in route.inputs.enumerated() {
            print("\(index + 1). \(input.portName) (\(input.portType))")
        }
        
        print("현재 출력 장치:")
        for (index, output) in route.outputs.enumerated() {
            print("\(index + 1). \(output.portName) (\(output.portType))")
        }
        
        print("====================\n")
    }
}
