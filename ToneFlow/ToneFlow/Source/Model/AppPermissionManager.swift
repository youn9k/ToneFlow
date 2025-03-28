import Foundation
import AVFoundation

enum AppPermissionManager {
    static func requestMicrophonePermission() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                print("마이크 권한 허용됨")
            } else {
                print("마이크 권한 거부됨")
            }
        }
    }
}
