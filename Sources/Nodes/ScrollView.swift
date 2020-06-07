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

extension ScrollView: UIKitNodeResolvable {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "ScrollView<\(content.hierarchyIdentifier)>"
        }

        let scrollView = ContainerScrollView()

        var content: AnyUIKitNode!
        var axes: Axis.Set!

        func update(view: ScrollView<Content>, context: Context) {
            self.axes = view.axes
            self.content = view.content.resolve(context: context, cachedNode: content)
            scrollView.showsVerticalScrollIndicator = view.showsIndicators
            scrollView.showsHorizontalScrollIndicator = view.showsIndicators
            scrollView.alwaysBounceVertical = view.axes.contains(.vertical)
            scrollView.alwaysBounceHorizontal = view.axes.contains(.horizontal)
        }

        func layoutSize(fitting targetSize: CGSize) -> CGSize {
            if axes == [.horizontal, .vertical] {
                return targetSize
            } else if axes == [.vertical] {
                var size = content.layoutSize(fitting: .init(width: targetSize.width, height: 0))
                size.height = targetSize.height
                return size
            } else if axes == [.horizontal] {
                var size = content.layoutSize(fitting: .init(width: 0, height: targetSize.height))
                size.width = targetSize.width
                return size
            } else {
                fatalError()
            }
        }

        func layout(in container: Container, bounds: Bounds) {
            let contentSize = content.layoutSize(fitting: bounds.size)
            scrollView.frame = bounds.rect
            scrollView.contentSize = contentSize
            container.view.addSubview(scrollView)
            content.layout(
                in: container.replacingView(scrollView),
                bounds: bounds.update(to: .init(origin: .zero, size: contentSize))
            )
        }

    }

    func resolve(context: Context, cachedNode: AnyUIKitNode?) -> AnyUIKitNode {
        return (cachedNode as? Node) ?? Node()
    }
}
