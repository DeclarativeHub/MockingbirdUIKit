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

public protocol AnyUIKitNodeModifier {

    var isSpacer: Bool { get }

    var layoutPriority: Double { get }

    func update(viewModifier: SomeViewModifier, context: inout Context)

    func layoutSize(fitting targetSize: CGSize, node: AnyUIKitNode) -> CGSize

    func layout(in container: Container, bounds: Bounds, node: AnyUIKitNode)
}

public protocol UIKitNodeModifier: AnyUIKitNodeModifier {

    associatedtype ViewModifier: SomeViewModifier

    func update(viewModifier: ViewModifier, context: inout Context)
}

extension AnyUIKitNodeModifier {

    public var isSpacer: Bool {
        false
    }

    public var layoutPriority: Double {
        0
    }

    func update(viewModifier: SomeViewModifier, context: inout Context) {
        
    }

    func layoutSize(fitting targetSize: CGSize, node: AnyUIKitNode) -> CGSize {
        node.layoutSize(fitting: targetSize)
    }

    func layout(in container: Container, bounds: Bounds, node: AnyUIKitNode) {
        node.layout(in: container, bounds: bounds)
    }
}

extension UIKitNodeModifier {

    public func update(viewModifier: SomeViewModifier, context: inout Context) {
        update(viewModifier: viewModifier as! ViewModifier, context: &context)
    }
}
