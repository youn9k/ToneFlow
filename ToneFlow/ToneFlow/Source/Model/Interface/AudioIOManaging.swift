//
//  AudioIOManaging.swift
//  ToneFlow
//
//  Created by YoungK on 4/15/25.
//

protocol AudioIOManaging {
    var availableInputs: [AudioPortDescription] { get }
    var currentInput: AudioPortDescription? { get }
    var currentOutput: AudioPortDescription? { get }
    func selectInput(named name: String) -> Bool
    func observeRouteChanges()
}
