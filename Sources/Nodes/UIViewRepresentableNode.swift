//
//  UIViewRepresentableNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 23/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class UIViewRepresentableNode: UIKitNode<AnyView> {

    override var hierarchyIdentifier: String {
        return "UIView"
    }

    private var uiView: UIView?

    private var uiViewRepresentable: AnyUIViewRepresentable {
        return view.content as! AnyUIViewRepresentable
    }

    override func update(_ view: AnyView, context: Context) {
        super.update(view, context: context)
        if let uiView = uiView {
            uiViewRepresentable._updateUIView(uiView, context: context)
        }
    }

    override func layoutSize(fitting size: CGSize) -> CGSize {
        return uiViewRepresentable.layoutSize(fitting: size)
    }

    override func layout(in parent: UIView, bounds: CGRect) {
        let uiView = self.uiView ?? uiViewRepresentable._makeUIView(context: context)
        self.uiView = uiView
        uiView.frame = bounds
        parent.addSubview(uiView)
    }
}

