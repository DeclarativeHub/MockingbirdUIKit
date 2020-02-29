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

    func _makeUIView(context: Context) -> UIView
    func _updateUIView(_ uiView: UIView, context: Context)

    func layoutSize(fitting size: CGSize) -> CGSize
}

public protocol UIViewRepresentable: AnyUIViewRepresentable, View where Body == Never {

    associatedtype UIViewType: UIView

    func makeUIView(context: Context) -> UIViewType
    func updateUIView(_ uiView: UIViewType, context: Context)
}

extension UIViewRepresentable {

    public func updateUIView(_ uiView: UIViewType, context: Context) {
    }

    public func layoutSize(fitting size: CGSize) -> CGSize {
        return size
    }

    public func _makeUIView(context: Context) -> UIView {
        return makeUIView(context: context)
    }

    public func _updateUIView(_ uiView: UIView, context: Context) {
        updateUIView(uiView as! UIViewType, context: context)
    }
}

class UIViewRepresentableNode: BaseUIKitNode<AnyView, StaticGeometry, UIView> {

    private var uiViewRepresentable: AnyUIViewRepresentable {
        view as! AnyUIViewRepresentable
    }

    override func update(_ view: AnyView, context: Context) {
        super.update(view, context: context)
        uiViewRepresentable._updateUIView(renderable, context: context)
    }

    override func calculateGeometry(fitting targetSize: CGSize) -> StaticGeometry {
        StaticGeometry(idealSize: uiViewRepresentable.layoutSize(fitting: targetSize))
    }

    override func makeRenderable() -> UIView {
        uiViewRepresentable._makeUIView(context: context)
    }
}
