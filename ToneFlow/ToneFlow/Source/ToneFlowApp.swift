import SwiftUI

@main
struct ToneFlowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    AppPermissionManager.requestMicrophonePermission()
                }
        }
    }
}
