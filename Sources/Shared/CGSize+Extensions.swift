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

import CoreGraphics

extension CGSize: Hashable {

    public func hash(into hasher: inout Hasher) {
        width.hash(into: &hasher)
        height.hash(into: &hasher)
    }
}

extension CGSize {

    var flipped: CGSize {
        return CGSize(width: height, height: width)
    }

    func verticallyAdding(_ other: CGSize) -> CGSize {
        return CGSize(
            width: max(width, other.width),
            height: height + other.height
        )
    }

    func horizontallyAdding(_ other: CGSize) -> CGSize {
        return CGSize(width: width + other.width, height: max(height, other.height))
    }

    func intersection(_ other: CGSize) -> CGSize {
        return CGSize(
            width: min(width, other.width),
            height: min(height, other.height)
        )
    }

    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}

func max(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
    return CGSize(width: max(lhs.width, rhs.width), height: max(lhs.height, rhs.height))
}

func min(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
    return CGSize(width: min(lhs.width, rhs.width), height: min(lhs.height, rhs.height))
}
