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
    /// 노브의 값: 중앙 0.5, 오른쪽(90°) 1.0, 왼쪽(-90°) 0.0
    @Binding var knobValue: Double
    /// 드래그 시작 시의 회전각
    @State private(set) var initialAngle: Double = 0.0
    /// 노브 회전 민감도
    private(set) var sensitive: Double = 0.5
    
    
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
        }
    }
    private var verticalDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                // translation.height가 음수면 위로 드래그 → angle 증가 (오른쪽 회전)
                var newAngle = initialAngle - value.translation.height * sensitive
                // angle은 -120 ~ 120 범위로 제한
                newAngle = min(max(newAngle, -120), 120)
                angle = newAngle
                knobValue = (newAngle + 120) / 180
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
