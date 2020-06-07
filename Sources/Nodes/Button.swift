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

extension Button: UIKitNodeResolvable {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "Button<\(label.hierarchyIdentifier)>"
        }

        var view: Button!
        var label: AnyUIKitNode!

        let control = Control()

        func update(view: Button, context: Context) {
            self.view = view
            var context = context
            context.environment.foregroundColor = context.environment.accentColor
            self.label = view.label.resolve(context: context, cachedNode: label)
            control.tappedHandler = view.action
        }

        func layoutSize(fitting targetSize: CGSize) -> CGSize {
            label.layoutSize(fitting: targetSize)
        }

        func layout(in container: Container, bounds: Bounds) {
            control.frame = bounds.rect
            container.view.addSubview(control)
            label.layout(
                in: container.replacingView(control),
                bounds: bounds.at(origin: .zero)
            )
        }
    }

    func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        return (cachedNode as? Node) ?? Node()
    }
}

extension Button {

    class Control: ContainerControl {

        var tappedHandler: (() -> Void)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            addTarget(self, action: #selector(tapped), for: .touchUpInside)
            addTarget(self, action: #selector(highlight), for: .touchDown)
            addTarget(self, action: #selector(unhighlight), for: .touchUpInside)
            addTarget(self, action: #selector(unhighlight), for: .touchUpOutside)
            addTarget(self, action: #selector(unhighlight), for: .touchCancel)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc dynamic private func unhighlight() {
            if #available(iOS 10.0, *) {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.1,
                    delay: 0,
                    options: [],
                    animations: { self.alpha = 1 },
                    completion: nil
                )
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.alpha = 1
                }
            }
        }

        @objc dynamic private func highlight() {
            if #available(iOS 10.0, *) {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.1,
                    delay: 0,
                    options: [],
                    animations: { self.alpha = 0.5 },
                    completion: nil
                )
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.alpha = 0.5
                }
            }
        }

        @objc func tapped() {
            tappedHandler?()
        }
    }
}
