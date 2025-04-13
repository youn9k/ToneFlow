//
//  TFSliderView.swift
//  ToneFlow
//
//  Created by YoungK on 4/6/25.
//

import SwiftUI

struct SliderView: View {
    @Binding var value: Double {
        didSet {
            #if DEBUG
            print(value)
            #endif
        }
    }
    var minValue: Double = -12
    var maxValue: Double = 12
    var trackColor: Color?
    var handleColor: Color?
        
    var body: some View {
        GeometryReader { geometry in
            let totalHeight = geometry.size.height
            let handleHeight: CGFloat = min(totalHeight / 7, 20) // 최대 20까지
            let dragRange = totalHeight - handleHeight
            
            ZStack {
                // 트랙 (캡슐 형태)
                Capsule()
                    .foregroundStyle(trackColor ?? Color.gray)
                
                // 핸들
                Capsule()
                    .foregroundStyle(handleColor ?? Color.blue)
                    .tfShadow(alpha: 0.1, blur: 10, x: 0, y: 4)
                    .frame(height: handleHeight)
                    .position(x: geometry.size.width / 2, y: handlePosition(for: dragRange, handleHeight: handleHeight))
            }
            .contentShape(Rectangle()) // 전체 영역을 터치 가능하게 함
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let locationY = gesture.location.y
                        // 핸들의 전체 높이를 제외한 실제 이동 가능한 범위 계산
                        let adjustedHeight = totalHeight - handleHeight
                        
                        // 위치를 0과 adjustedHeight 사이로 제한
                        let clampedY = min(max(locationY, handleHeight/2), totalHeight - handleHeight/2) - handleHeight/2
                        
                        // 정규화된 값 계산 (0-1 범위)
                        let newNormalized = 1 - (clampedY / adjustedHeight)
                        
                        // 최종 값 계산
                        let newValue = minValue + (maxValue - minValue) * Double(newNormalized)
                        
                        // 현재 이미 최대값이거나 최소값이라면 변경하지 않음
                        if (value == maxValue && newValue >= maxValue) || 
                           (value == minValue && newValue <= minValue) {
                            return
                        }
                        
                        // 값이 범위를 벗어나지 않게 제한
                        value = max(min(newValue, maxValue), minValue)
                    }
            )
        }
    }
    
    // 핸들의 y 위치 계산
    func handlePosition(for dragRange: CGFloat, handleHeight: CGFloat) -> CGFloat {
        let normalizedValue = (value - minValue) / (maxValue - minValue)
        let position = (1 - CGFloat(normalizedValue)) * dragRange + handleHeight / 2
        return position
    }
}

#Preview {
    SliderView(
        value: .constant(0.5),
        trackColor: Color.gray300,
        handleColor: Color.POINT_2
    )
        .frame(width: 10, height: 180)
}
