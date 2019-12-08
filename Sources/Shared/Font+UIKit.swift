//
//  Font+UIFont.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 13/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension Font.Weight {

    var uiFontWeightValue: UIFont.Weight {
        switch self {
        case .ultraLight:
            return .ultraLight
        case .thin:
            return .thin
        case .light:
            return .light
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        case .heavy:
            return .heavy
        case .black:
            return .black
        }
    }
}

extension Font.Descriptor {

    private static var cache: [Font.Descriptor: UIFont] = [:]

    var uiFontValue: UIFont {
        if let font = Self.cache[self] {
            return font
        }
        let font: UIFont
        switch self {
        case .system(let size, var weight, let design, let attributes):
            // TODO: improve mapping
            if attributes.isBold {
                weight = .bold
            }
            switch design {
            case .default:
                font = .systemFont(ofSize: size, weight: weight.uiFontWeightValue)
            case .monospaced:
                if #available(iOS 12.0, *) {
                    font = .monospacedSystemFont(ofSize: size, weight: weight.uiFontWeightValue)
                } else {
                    font = .monospacedDigitSystemFont(ofSize: size, weight: weight.uiFontWeightValue)
                }
            default:
                fatalError()
            }
        case .custom(let name, let size):
            font = UIFont(name: name, size: size)!
        }
        Self.cache[self] = font
        return font
    }
}

extension Font {

    var uiFontValue: UIFont {
        return descriptor.uiFontValue
    }
}
