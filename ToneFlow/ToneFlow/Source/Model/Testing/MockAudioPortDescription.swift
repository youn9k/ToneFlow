//
//  MockAudioPortDescription.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import AVFAudio

struct MockAudioPortDescription: AudioPortDescription {
    var name: String
    var identifier: String
    var port: AVAudioSession.Port
    var dataSource: [AVAudioSessionDataSourceDescription]?
}
