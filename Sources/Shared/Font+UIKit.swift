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

    var uiFontValue: UIFont {
        switch self {
        case .system(let size, let weight, _, let attributes):
            // TODO: improve mapping
            if attributes.isBold {
                return .boldSystemFont(ofSize: size)
            } else if attributes.isItalic {
                return .italicSystemFont(ofSize: size)
            } else if attributes.isMonospacedDigit {
                return .monospacedDigitSystemFont(ofSize: size, weight: weight.uiFontWeightValue)
            } else {
                return .systemFont(ofSize: size)
            }
        case .custom(let name, let size):
            return UIFont(name: name, size: size)!
        }
    }
}

extension Font {

    var uiFontValue: UIFont {
        return descriptor.uiFontValue
    }
}
