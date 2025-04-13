//
//  TFVolumeMeterView.swift
//  ToneFlow
//
//  Created by YoungK on 4/4/25.
//

import SwiftUI

struct TFVolumeMeterView: View {
    @Binding var volume: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let currentVolumeHeight = height * CGFloat(volume)
            
            Rectangle()
                .foregroundStyle(.gray300)
                .frame(width: width, height: height)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .foregroundStyle(.gray600)
                        .frame(height: currentVolumeHeight)
                }
        }  
    }
}

#Preview {
    TFVolumeMeterView(volume: .constant(0.7))
        .frame(width: 10, height: 100)
}
