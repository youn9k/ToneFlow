//
//  MathUtils.swift
//  ToneFlow
//
//  Created by YoungK on 4/13/25.
//

import Foundation

public enum MathUtils {
    /// 값을 지정된 범위 내로 제한합니다.
    /// - Parameters:
    ///   - value: 제한할 값
    ///   - min: 최소값
    ///   - max: 최대값
    /// - Returns: 범위 내로 제한된 값
    public static func clamp<T: Comparable>(_ value: T, min minValue: T, max maxValue: T) -> T {
        return Swift.min(Swift.max(value, minValue), maxValue)
    }
    
    /// 값을 비율에 따라 다른 범위로 매핑합니다.
    /// - Parameters:
    ///   - value: 매핑할 값
    ///   - fromMin: 원래 범위의 최소값
    ///   - fromMax: 원래 범위의 최대값
    ///   - toMin: 새 범위의 최소값
    ///   - toMax: 새 범위의 최대값
    /// - Returns: 새 범위로 매핑된 값
    public static func map<T: FloatingPoint>(_ value: T, fromMin: T, fromMax: T, toMin: T, toMax: T) -> T {
        return toMin + (toMax - toMin) * ((value - fromMin) / (fromMax - fromMin))
    }
}

// MARK: - Comparable Extension
public extension Comparable {
    /// 값을 지정된 범위 내로 제한합니다.
    /// - Parameters:
    ///   - min: 최소값
    ///   - max: 최대값
    /// - Returns: 범위 내로 제한된 값
    func clamped(to range: ClosedRange<Self>) -> Self {
        return MathUtils.clamp(self, min: range.lowerBound, max: range.upperBound)
    }
    
    /// 값을 지정된 범위 내로 제한합니다.
    /// - Parameters:
    ///   - min: 최소값
    ///   - max: 최대값
    /// - Returns: 범위 내로 제한된 값
    func clamped(min: Self, max: Self) -> Self {
        return MathUtils.clamp(self, min: min, max: max)
    }
} 
