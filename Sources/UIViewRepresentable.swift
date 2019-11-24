//
//  UIViewRepresentable.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 23/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

public protocol AnyUIViewRepresentable: View {

    func _makeUIView(context: Context) -> UIView
    func _updateUIView(_ uiView: UIView, context: Context)

    func layoutSize(fitting size: CGSize) -> CGSize
}

public protocol UIViewRepresentable: AnyUIViewRepresentable {

    associatedtype UIViewType: UIView

    func makeUIView(context: Context) -> UIViewType
    func updateUIView(_ uiView: UIViewType, context: Context)
}

extension UIViewRepresentable {

    public var body: View {
        fatalError()
    }

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
