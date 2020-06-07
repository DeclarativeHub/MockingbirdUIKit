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

public protocol AnyUIViewRepresentable: SomeView {

    func __makeCoordinator() -> Any
    func __makeUIView(context: Any) -> UIView
    func __updateUIView(_ uiView: UIView, context: Any)
    func __makeContext(context: Context, coordinator: Any) -> Any
}

public protocol UIViewRepresentable: AnyUIViewRepresentable, View where Body == Never {

    associatedtype UIViewType: UIView
    associatedtype Coordinator = Void

    typealias Context = UIViewRepresentableContext<Self>

    func makeCoordinator() -> Coordinator
    func makeUIView(context: Context) -> UIViewType
    func updateUIView(_ uiView: UIViewType, context: Context)
}

public struct UIViewRepresentableContext<Representable> where Representable: UIViewRepresentable {

    public let coordinator: Representable.Coordinator

    public var transaction: Transaction {
        context.transaction
    }

    public var environment: EnvironmentValues {
        context.environment
    }

    internal let context: Context
}

extension UIViewRepresentable where Coordinator == Void {

    public func makeCoordinator() -> Void {
    }
}

extension UIViewRepresentable {

    public func __makeCoordinator() -> Any {
        makeCoordinator()
    }

    public func __makeUIView(context: Any) -> UIView {
        makeUIView(context: context as! Context)
    }

    public func __updateUIView(_ uiView: UIView, context: Any) {
        updateUIView(uiView as! UIViewType, context: context as! Context)
    }

    public func __makeContext(context: Mockingbird.Context, coordinator: Any) -> Any {
        UIViewRepresentableContext<Self>(coordinator: coordinator as! Coordinator, context: context)
    }
}

class UIViewRepresentableNode: AnyUIKitNode {

    var hierarchyIdentifier: String {
        "\(type(of: uiView))"
    }

    var uiView: UIView!
    var coordinator: Any!

    func update(view: SomeView, context: Context) {
        let view = view as! AnyUIViewRepresentable
        if let uiView = self.uiView {
            let context = view.__makeContext(context: context, coordinator: coordinator as Any)
            view.__updateUIView(uiView, context: context)
        } else {
            self.coordinator = view.__makeCoordinator()
            let context = view.__makeContext(context: context, coordinator: coordinator as Any)
            self.uiView = view.__makeUIView(context: context)
            view.__updateUIView(self.uiView, context: context)
        }
    }

    func layoutSize(fitting targetSize: CGSize) -> CGSize {
        let size = uiView.intrinsicContentSize
        return max(size, targetSize)
    }

    func layout(in container: Container, bounds: Bounds) {
        uiView.frame = bounds.rect
        container.view.addSubview(uiView)
    }

}
