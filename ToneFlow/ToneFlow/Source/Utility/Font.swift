import SwiftUI

protocol Fontable {
    var font: Font { get }
    var lineHeight: CGFloat { get }
}

public extension View {
    func tfFont(_ style: Font.FontSystem) -> some View {
        self.font(style.font)
    }
    
    func tfLineSpacing(_ style: Font.FontSystem) -> some View {
        let spacing = style.lineHeight - style.size
        return self.lineSpacing(spacing)
    }
}

public extension Font {
    enum FontSystem: Fontable {
        /// size: 24
        case t1(weight: FontWeight = .medium)
        /// size: 22
        case t2(weight: FontWeight = .medium)
        /// size: 20
        case t3(weight: FontWeight = .medium)
        /// size: 16
        case t4(weight: FontWeight = .medium)
        /// size: 14
        case t5(weight: FontWeight = .medium)
        /// size: 12
        case t6(weight: FontWeight = .medium)
    }

    static func setFont(_ style: FontSystem) -> Font {
        return style.font
    }
}

public extension Font.FontSystem {
    enum FontWeight {
        case light, medium, bold
    }

    var font: Font {
        return .custom(weight.font, size: size)
    }
    
    var lineHeight: CGFloat {
        return height
    }
}

// MARK: - private

private extension Font.FontSystem {
    var weight: FontWeight {
        switch self {
        case let .t1(weight),
             let .t2(weight),
             let .t3(weight),
             let .t4(weight),
             let .t5(weight),
             let .t6(weight):
            return weight
        }
    }

    var size: CGFloat {
        switch self {
        case .t1: return 24
        case .t2: return 22
        case .t3: return 20
        case .t4: return 16
        case .t5: return 14
        case .t6: return 12
        }
    }

    var height: CGFloat {
        switch self {
        case .t1: return 36
        case .t2: return 32
        case .t3: return 32
        case .t4: return 28
        case .t5: return 24
        case .t6: return 22
        }
    }
}

private extension Font.FontSystem.FontWeight {
    var font: String {
        switch self {
        case .light: return "Pretendard-Light"
        case .medium: return "Pretendard-Medium"
        case .bold: return "Pretendard-Bold"
        }
    }
}
