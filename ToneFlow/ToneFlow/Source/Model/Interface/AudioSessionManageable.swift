//
//  AudioSessionManageable.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

import Combine

protocol AudioSessionManageable {
    var availableInputsPublisher: AnyPublisher<[AudioPortDescription], Never> { get }
    var currentInputPublisher: AnyPublisher<AudioPortDescription?, Never> { get }
    var currentOutputPublisher: AnyPublisher<AudioPortDescription?, Never> { get }
    var currentInputGainPublisher: AnyPublisher<Float, Never> { get }
    var currentOutputVolumePublisher: AnyPublisher<Float, Never> { get }
    
    func setInputGain(_ gain: Float) throws
    func setOutputVolume(_ volume: Float)
}

extension AudioSessionManageable {
    func setInputGain(_ gain: Float) throws {}
    func setOutputVolume(_ volume: Float) {}
}
