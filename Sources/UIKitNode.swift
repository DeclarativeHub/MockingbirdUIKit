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

public protocol AnyUIKitNode: LayoutNode {

    var hierarchyIdentifier: String { get }

    var isSpacer: Bool { get }

    var layoutPriority: Double { get }

    func update(view: SomeView, context: Context)

    func layoutSize(fitting targetSize: CGSize, pass: LayoutPass) -> CGSize

    func layout(in container: Container, bounds: Bounds, pass: LayoutPass)
}

public protocol UIKitNode: AnyUIKitNode {

    associatedtype View: SomeView

    func update(view: View, context: Context)
}

extension AnyUIKitNode {

    public var isSpacer: Bool {
        false
    }

    public var layoutPriority: Double {
        0
    }
}

extension UIKitNode {

    public func update(view: SomeView, context: Context) {
        update(view: view as! View, context: context)
    }
}
