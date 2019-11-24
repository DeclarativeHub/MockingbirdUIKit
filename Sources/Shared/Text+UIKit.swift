//
//  Text.Storage+UIKit.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 13/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension Text.Storage {

    var stringValue: String {
        switch self {
        case .plain(let stringValue):
            return stringValue
        case .attributed(let storage, _):
            return storage.stringValue
        case .concatenated(let lhs, let rhs):
            return lhs.stringValue + rhs.stringValue
        }
    }

    func attributedStringValue(baseFont: Font) -> NSAttributedString {
        let string = NSMutableAttributedString()
        string.parse(self, font: baseFont, attributes: [.font: baseFont.uiFontValue])
        return string
    }

    var isAttributed: Bool {
        switch self {
        case .plain:
            return false
        case .attributed:
            return true
        case .concatenated(let lhs, let rhs):
            return lhs.isAttributed || rhs.isAttributed
        }
    }
}

extension Text.Storage {

    func boundingSize(fitting size: CGSize, env: EnvironmentValues) -> CGSize {
        if isAttributed {
            return attributedStringValue(baseFont: env.font).boundingRect(
                with: max(size, .zero),
                options: [.usesLineFragmentOrigin],
                context: nil
            ).size
        } else {
            let nsString = stringValue as NSString
            let font = env.font.descriptor.uiFontValue
            return nsString.boundingRect(
                with: max(size, .zero),
                options: [.usesLineFragmentOrigin],
                attributes: [.font: font],
                context: nil
            ).size
        }
    }
}

extension NSMutableAttributedString {

    func parse(_ storage: Text.Storage, font: Font, attributes: [NSAttributedString.Key: Any]?) {
        switch storage {
        case .plain(let string):
            append(NSAttributedString(string: string, attributes: attributes))
        case .concatenated(let lhs, let rhs):
            parse(lhs, font: font, attributes: attributes)
            parse(rhs, font: font, attributes: attributes)
        case .attributed(let storage, let attribute):
            var attributes = attributes ?? [:]
            switch attribute {
            case .foregroundColor(let color):
                attributes[.foregroundColor] = color?.uiColorValue
            case .font(let font):
                attributes[.font] = font?.uiFontValue
            case .fontWeight(let weight):
                attributes[.font] = font.weight(weight ?? .regular).uiFontValue
            case .bold:
                attributes[.font] = font.bold().uiFontValue
            case .italic:
                attributes[.font] = font.italic().uiFontValue
            case .strikethrough(let active, let color):
                attributes[.strikethroughStyle] = NSNumber(value: active ? NSUnderlineStyle.single.rawValue : 0)
                attributes[.strikethroughColor] = active ? color?.uiColorValue : nil
            case .underline(let active, let color):
                attributes[.underlineStyle] = NSNumber(value: active ? NSUnderlineStyle.single.rawValue : 0)
                attributes[.underlineColor] = color?.uiColorValue
            case .kerning(let kerning):
                attributes[.kern] = kerning.map { NSNumber.init(value: Float($0)) }
            case .tracking:
                fatalError()
            case .baselineOffset(let baselineOffset):
                attributes[.baselineOffset] = baselineOffset.map { NSNumber.init(value: Float($0)) }
            }
            parse(storage, font: font, attributes: attributes)
        }
    }
}
