//
//  SystemVolumeController.swift
//  ToneFlow
//
//  Created by YoungK on 4/17/25.
//

import UIKit
import MediaPlayer

final class SystemVolumeController {
    private let volumeView = MPVolumeView(frame: .zero)

    func setVolume(_ value: Float) {
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        slider?.value = value
    }
}
