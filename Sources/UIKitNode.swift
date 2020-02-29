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

public protocol UIKitNode: AnyObject, LayoutableNode, LayoutNode {

    var hierarchyIdentifier: String { get }

    init(_ view: SomeView, context: Context)

    func update(_ view: SomeView, context: Context)

    func invalidateRenderingState()

    func didMoveToParent(_ node: UIKitNode)
}

open class BaseUIKitNode<V: View, Geometry: UIKitNodeGeometry, Renderable: LayoutableNode>: UIKitNode {

    public var isSpacer: Bool {
        false
    }

    public var layoutPriority: Double {
        0
    }

    public var hierarchyIdentifier: String {
        String(describing: V.self)
    }

    public var view: V

    public var context: Context
    
    public var env: EnvironmentValues {
        context.environment
    }

    public weak var parentNode: UIKitNode?

    public var layoutableChildNodes: [LayoutableNode] {
        [renderable]
    }

    private var isInvalidated = true

    private var geometryCache: [CGSize: Geometry] = [:]

    public private(set) lazy var renderable = makeRenderable()

    public required init(_ view: SomeView, context: Context) {
        self.view = view as! V
        self.context = context
        update(self.view, context: context)
    }

    open func update(_ view: V, context: Context) {
        self.view = view
        self.context = context
    }

    open func update(_ view: SomeView, context: Context) {
        self.update(view as! V, context: context)
    }

    open func layoutSize(fitting size: CGSize) -> CGSize {
        return geometry(fitting: size).idealSize
    }

    open func makeRenderable() -> Renderable {
        if Renderable.self == NoRenderable.self {
            return NoRenderable() as! Renderable
        } else {
            fatalError("To be implemented in a subclass")
        }
    }

    open func calculateGeometry(fitting targetSize: CGSize) -> Geometry {
        fatalError("To be implemented in a subclass")
    }

    open func updateRenderable() {
    }

    public func geometry(fitting targetSize: CGSize) -> Geometry {
        if let geometry = geometryCache[targetSize] {
            print("Reading geometry from cache for", self)
            return geometry
        } else {
            print("Calculating new geometry for", self)
            let geometry = calculateGeometry(fitting: targetSize)
            geometryCache[targetSize] = geometry
            return geometry
        }
    }

    public func invalidateRenderingState() {
        print("Invalidating", self)
        isInvalidated = true
        parentNode?.invalidateRenderingState()
        context.rendered?.setNeedsRendering()
    }

    public func didMoveToParent(_ node: UIKitNode) {
        parentNode = node
    }

    open func layout(in container: Container, bounds: Bounds) {
        if isInvalidated {
            isInvalidated = false
            geometryCache.removeAll(keepingCapacity: true)
            updateRenderable()
        }
        layout(in: container, bounds: bounds, geometry: geometry(fitting: bounds.size))
    }

    open func layout(in container: Container, bounds: Bounds, geometry: Geometry) {
        geometry.layout(nodes: layoutableChildNodes, in: container, bounds: bounds)
    }
}

class BaseUIKitModifierNode<Modifier: ViewModifier, Geometry: UIKitNodeGeometry, Renderable: LayoutableNode>: BaseUIKitNode<ModifiedContent<ViewModifierContent<Modifier>, Modifier>, Geometry, Renderable> {

    public override var hierarchyIdentifier: String {
        "\(String(describing: Modifier.self))[\(node.hierarchyIdentifier)]"
    }

    override var layoutableChildNodes: [LayoutableNode] {
        [node]
    }

    var node: UIKitNode!

    var modifier: Modifier {
        view.modifier
    }

    override func update(_ view: ModifiedContent<ViewModifierContent<Modifier>, Modifier>, context: Context) {
        super.update(view, context: context)
        self.node = view.content.resolve(context: context, cachedNode: node)
        self.node.didMoveToParent(self)
    }
}
