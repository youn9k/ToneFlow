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
    func observeRouteChanges()
}

extension AudioSessionManageable {
    // Optional
    func observeRouteChanges() {}
}
