//
//  AudioPortDescription.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import AVFAudio

protocol AudioPortDescription {
    /// wrapped for AVAudioSesionPortDesription.portName
    var name: String { get }
    
    /// wrapped for AVAudioSesionPortDesription.uid
    var identifier: String { get }
    
    /// wrapped for AVAudioSesionPortDesription.portType
    var port: AVAudioSession.Port { get }
    
    /// wrapped for AVAudioSesionPortDesription.dataSources
    var dataSource: [AVAudioSessionDataSourceDescription]? { get }
}

extension AVAudioSessionPortDescription: AudioPortDescription {
    var name: String {
        return self.portName
    }
    
    var identifier: String {
        self.uid
    }
    
    var port: AVAudioSession.Port {
        return self.portType
    }
    
    var dataSource: [AVAudioSessionDataSourceDescription]? {
        return self.dataSources
    }
}
