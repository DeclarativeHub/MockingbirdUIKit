// MIT License
//
// Copyright (c) 2020 Declarative Hub
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
