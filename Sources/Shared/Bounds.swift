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

public struct Bounds {
    public let rect: CGRect
    public let safeAreaInsets: EdgeInsets

    public init(rect: CGRect, safeAreaInsets: EdgeInsets) {
        self.rect = rect
        self.safeAreaInsets = safeAreaInsets
    }
}

extension Bounds {

    @inlinable
    public var origin: CGPoint {
        rect.origin
    }

    @inlinable
    public var size: CGSize {
        rect.size
    }

    public func unsafeRect(edges: Edge.Set = .all) -> CGRect {
        rect.inset(by:
            EdgeInsets(
                top: edges.contains(.top) ? -safeAreaInsets.top : 0,
                leading: edges.contains(.leading) ? -safeAreaInsets.leading : 0,
                bottom: edges.contains(.bottom) ? -safeAreaInsets.bottom : 0,
                trailing: edges.contains(.trailing) ? -safeAreaInsets.trailing : 0
            )
        )
    }

    public func offset(dx: CGFloat, dy: CGFloat) -> Bounds {
        Bounds(
            rect: rect.offsetBy(dx: dx, dy: dy),
            safeAreaInsets: safeAreaInsets // TODO
        )
    }

    public func inset(by insets: EdgeInsets) -> Bounds {
        Bounds(
            rect: rect.inset(by: insets),
            safeAreaInsets: safeAreaInsets // TODO
        )
    }
}
