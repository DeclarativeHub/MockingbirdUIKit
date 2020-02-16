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

public class HostingView: ContainerView {

    private class Renderer: Mockingbird.Renderer {

        weak var hostingView: HostingView?

        init(hostingView: HostingView? = nil) {
            self.hostingView = hostingView
        }

        func setNeedsRendering() {
            hostingView?.setNeedsRendering()
        }
    }

    public var context: Context {
        didSet {
            context.rendered = Renderer(hostingView: self)
        }
    }

    public private(set) var view: View

    private var node: UIKitNode

    private var previousBounds: CGRect? = nil

    public init(_ view: View, context: Context = Context(), cachedNode: UIKitNode? = nil) {
        let renderer = Renderer()
        let context = modified(context) { $0.rendered = renderer }
        self.view = view
        self.context = context
        self.node = cachedNode ?? view.resolve(context: context, cachedNode: nil)
        super.init(frame: .zero)
        renderer.hostingView = self
    }

    public func updateView(_ view: View, resolvedNode: UIKitNode? = nil) {
        self.view = view
        self.node = resolvedNode ?? view.resolve(context: context, cachedNode: nil)
        self.setNeedsRendering()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let bounds: CGRect
        if #available(iOS 11.0, *) {
            bounds = self.safeAreaLayoutGuide.layoutFrame
        } else {
            bounds = self.bounds
        }
        if previousBounds != bounds {
            previousBounds = bounds
            let container = Container(view: self, viewController: parentViewController!)
            replaceSubviews {
                node.layout(in: container, bounds: layoutBounds)
            }
        }
    }

    var layoutBounds: Bounds {
        if #available(iOS 11.0, *) {
            return Bounds(rect: bounds.inset(by: safeAreaInsets), safeAreaInsets: .init(safeAreaInsets))
        } else {
            return Bounds(rect: bounds, safeAreaInsets: .zero)
        }
    }

    public func setNeedsRendering() {
        previousBounds = nil
        setNeedsLayout()
    }
}

extension UIResponder {

    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
