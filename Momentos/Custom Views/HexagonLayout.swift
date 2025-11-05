//
//  HexagonLayout.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI

    // Este enum controla los diferentes tamaños de nuestros hexágonos.
    enum HexagonLayout {
        case standard
        case large

        // Tamaño del hexágono
        var size: CGFloat {
            switch self {
            case .standard:
                return 200.0
            case .large:
                return 350.0
            }
        }
        
        // Propiedades de padding y fuentes que usará MomentHexagonView
        var timestampBottomPadding: CGFloat { 0.08 }
        var textBottomPadding: CGFloat { 0.25 }
        var timestampHeight: CGFloat { size * (textBottomPadding - timestampBottomPadding) }
        var titleFont: Font {
            switch self {
            case .standard: return .headline
            case .large: return .title.bold()
            }
        }
        var bodyFont: Font {
            switch self {
            case .standard: return .caption2
            case .large: return .body
            }
        }
    }
