//
//  KnobView.swift
//  ToneFlow
//
//  Created by YoungK on 3/28/25.
//

import SwiftUI

struct KnobView: View {
    /// 회전 각도: 중앙은 0, 위로 드래그(오른쪽 회전)는 양수, 아래로 드래그(왼쪽 회전)는 음수
    @State private(set) var angle: Double = 0.0
    /// 노브의 값: 중앙 0.5, 오른쪽(90°) 1.0, 왼쪽(-90°) 0.0
    @State private(set) var knobValue: Double = 0.5
    /// 드래그 시작 시의 회전각
    @State private(set) var initialAngle: Double = 0.0
    /// 노브 회전 민감도
    private(set) var sensitive: Double = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            /// 부모 뷰가 지정한 크기 중 작은 쪽을 기준으로 계산
            let size = min(geometry.size.width, geometry.size.height)
            /// 원의 테두리 두께를 전체 크기의 4%로 설정
            let circleLineWidth = size * 0.04
            /// 포인터(노브 바늘)의 크기를 전체 크기에 비례하여 계산
            let pointerWidth = size * 0.02
            let pointerHeight = size * 0.4
            /// 포인터가 원 상단에 위치하도록 오프셋 계산
            let pointerOffset = -pointerHeight / 2
            
            ZStack {
                // 노브 배경: 원 형태의 테두리
                Circle()
                    .stroke(Color.gray, lineWidth: circleLineWidth)
                    .fill(.white)
                    .frame(width: size, height: size)
                
                // 노브 포인터(바늘)
                Rectangle()
                    .fill(Color.red)
                    .frame(width: pointerWidth, height: pointerHeight)
                    .offset(y: pointerOffset)
                    .rotationEffect(.degrees(angle))
            }
            // ZStack 자체의 크기를 GeometryReader의 크기로 설정
            .frame(width: geometry.size.width, height: geometry.size.height)
            .gesture(verticalDragGesture)
        }
    }
    private var verticalDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                // translation.height가 음수면 위로 드래그 → angle 증가 (오른쪽 회전)
                var newAngle = initialAngle - value.translation.height * sensitive
                // angle은 -90 ~ 90 범위로 제한
                newAngle = min(max(newAngle, -90), 90)
                angle = newAngle
                knobValue = (newAngle + 90) / 180
            }
            .onEnded { _ in
                initialAngle = angle
            }
    }
    
}

struct KnobView_Previews: PreviewProvider {
    static var previews: some View {
        KnobView()
    }
}
