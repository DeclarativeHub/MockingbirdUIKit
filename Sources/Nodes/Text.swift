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

extension Text: UIKitNodeResolvable {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "Text"
        }

        var text: Text?
        var env: EnvironmentValues?

        let label = UILabel()

        func update(view: Text, context: Context) {
            (text, env) = (view, context.environment)
            label.configure(with: view.storage, env: context.environment)
        }

        func layoutSize(fitting targetSize: CGSize, pass: LayoutPass) -> CGSize {
            guard let text = text, let env = env else { return .zero }
            return text.storage.boundingSize(fitting: targetSize, env: env)
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass) {
            container.view.addSubview(label)
            label.frame = bounds.rect
        }

    }

    func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        return (cachedNode as? Node) ?? Node()
    }
}

extension UILabel {

    func configure(with storage: Text.Storage, env: EnvironmentValues) {
        font = env.font.descriptor.uiFontValue
        numberOfLines = env.lineLimit ?? 0
        minimumScaleFactor = env.minimumScaleFactor
        adjustsFontSizeToFitWidth = minimumScaleFactor != 1
        textColor = env.foregroundColor?.uiColorValue

        switch env.multilineTextAlignment {
        case .leading:
            textAlignment = .left
        case .center:
            textAlignment = .center
        case .trailing:
            textAlignment = .right
        }

        switch env.truncationMode {
        case .head:
            lineBreakMode = .byTruncatingHead
        case .middle:
            lineBreakMode = .byTruncatingMiddle
        case .tail:
            lineBreakMode = .byTruncatingTail
        }

        if storage.isAttributed {
            attributedText = storage.attributedStringValue(baseFont: env.font)
        } else {
            text = storage.stringValue
        }
    }

}
