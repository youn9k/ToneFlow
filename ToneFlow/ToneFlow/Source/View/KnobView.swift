//
//  KnobView.swift
//  ToneFlow
//
//  Created by YoungK on 3/28/25.
//

import SwiftUI

struct KnobView: View {
    @Environment(\.knobFillColor) private var knobFillColor
    var knobColor: Color { knobFillColor ?? .gray700 }
    
    /// 회전 각도: 중앙은 0, 위로 드래그(오른쪽 회전)는 양수, 아래로 드래그(왼쪽 회전)는 음수
    @State private(set) var angle: Double = 0.0
    /// 노브의 값: 중앙 0.5, 왼쪽(-120°) 0.0, 오른쪽(120°) 1.0
    @Binding var knobValue: Double
    /// 드래그 시작 시의 회전각
    @State private(set) var initialAngle: Double = 0.0
    /// 노브 회전 민감도
    private(set) var sensitive: Double = 0.5
    
    // 노브 회전 제한 각도
    private let minAngle: Double = -120
    private let maxAngle: Double = 120
    
    var body: some View {
        GeometryReader { geometry in
            /// 부모 뷰가 지정한 크기 중 작은 쪽을 기준으로 계산
            let size = min(geometry.size.width, geometry.size.height)
            let pointerWidth = size / 8
            let pointerHeight = size / 8
            let pointerOffset = max(5.0, size / 16)
            
            Circle()
                .fill(knobColor)
                .strokeBorder(Color.white, lineWidth: 1)
                .frame(width: size, height: size)
                .overlay(alignment: .top) {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: pointerWidth, height: pointerHeight)
                        .offset(y: pointerOffset)
                }
                .rotationEffect(.degrees(angle))
                .gesture(verticalDragGesture)
                .onAppear {
                    // 초기 각도 설정: knobValue 0~1을 -120~120도로 변환
                    angle = MathUtils.map(knobValue, fromMin: 0, fromMax: 1, toMin: minAngle, toMax: maxAngle)
                }
        }
    }
    
    private var verticalDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                // translation.height가 음수면 위로 드래그 → angle 증가 (오른쪽 회전)
                var newAngle = initialAngle - value.translation.height * sensitive
                
                // angle은 minAngle ~ maxAngle 범위로 제한
                newAngle = newAngle.clamped(min: minAngle, max: maxAngle)
                
                // angle을 knobValue로 변환: minAngle~maxAngle 도에서 0~1로 변환
                let newValue = MathUtils.map(newAngle, fromMin: minAngle, fromMax: maxAngle, toMin: 0, toMax: 1)
                
                // 경계값(0 또는 1)에서 더 이상 변경하지 않도록 처리
                // 이미 0인데 더 작아지는 경우 또는 이미 1인데 더 커지는 경우 무시
                if (knobValue <= 0 && newValue <= 0) || (knobValue >= 1 && newValue >= 1) {
                    return
                }
                
                angle = newAngle
                knobValue = newValue
            }
            .onEnded { _ in
                initialAngle = angle
            }
    }
}

struct KnobView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            KnobView(knobValue: .constant(0.5))
                .knobFill(.POINT)
                .frame(width:  80, height: 80)
                .tfShadow(alpha: 0.25, blur: 10)
        }
    }
}
