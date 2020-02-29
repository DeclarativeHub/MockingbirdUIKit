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

extension Spacer: UIKitNodeResolvable {

    class Node: BaseUIKitNode<Spacer, StaticGeometry, NoRenderable> {

        var minLenght: CGFloat {
            view.minLength ?? (env._layoutAxis == .horizontal ? env.hStackSpacing : env.vStackSpacing)
        }

        override func update(_ view: Spacer, context: Context) {
            if view != self.view {
                invalidateRenderingState()
            }
            super.update(view, context: context)
        }

        override var isSpacer: Bool {
            true
        }

        override func calculateGeometry(fitting targetSize: CGSize) -> StaticGeometry {
            switch env._layoutAxis {
            case .horizontal:
                return StaticGeometry(idealSize: CGSize(width: minLenght, height: 0))
            case .vertical:
                return StaticGeometry(idealSize: CGSize(width: 0, height: minLenght))
            default:
                return StaticGeometry(idealSize: max(CGSize(width: minLenght, height: minLenght), targetSize))
            }
        }
    }
}
