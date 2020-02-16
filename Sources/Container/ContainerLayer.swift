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

public let kMockingbirdLayerName = "kMockableLayer"

public final class ContainerLayer: CALayer {

    private var sublayersToRemove: Set<CALayer> = []

    public override func addSublayer(_ layer: CALayer) {
        if layer.name == kMockingbirdLayerName {
            sublayersToRemove.remove(layer)
        }
        super.addSublayer(layer)
    }

    public func replaceSublayers(_ block: () -> Void) {
        sublayersToRemove = Set(sublayers?.filter { $0.name == kMockingbirdLayerName } ?? [])
        block()
        sublayersToRemove.forEach { $0.removeFromSuperlayer() }
    }
}

extension CALayer {

    public static func mockingbirdLayer() -> Self {
        let layer = self.init()
        layer.name = kMockingbirdLayerName
        return layer
    }
}