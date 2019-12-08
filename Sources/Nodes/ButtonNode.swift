//
//  ButtonNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 15/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class ButtonNode: UIKitNode<Button> {

    class Control: RendererControl {

        var tappedHandler: (() -> Void)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            addTarget(self, action: #selector(tapped), for: .touchUpInside)
            addTarget(self, action: #selector(highlight), for: .touchDown)
            addTarget(self, action: #selector(unhighlight), for: .touchUpInside)
            addTarget(self, action: #selector(unhighlight), for: .touchUpOutside)
            addTarget(self, action: #selector(unhighlight), for: .touchCancel)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc dynamic private func unhighlight() {
            if #available(iOS 10.0, *) {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.1,
                    delay: 0,
                    options: [],
                    animations: { self.alpha = 1 },
                    completion: nil
                )
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.alpha = 1
                }
            }
        }

        @objc dynamic private func highlight() {
            if #available(iOS 10.0, *) {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.1,
                    delay: 0,
                    options: [],
                    animations: { self.alpha = 0.5 },
                    completion: nil
                )
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.alpha = 0.5
                }
            }
        }

        @objc func tapped() {
            tappedHandler?()
        }
    }

    override var hierarchyIdentifier: String {
        return "B[\(label.hierarchyIdentifier)]"
    }

    private var label: AnyUIKitNode
    private var control: Control!

    required init(_ view: Button, context: Context, resolver: UIKitNodeResolver) {
        var context = context
        context.environment.foregroundColor = context.environment.accentColor
        self.label = resolver.resolve(view.label, context: context, cachedNode: nil)
        super.init(view, context: context, resolver: resolver)
        label.parentNode = self
    }

    override func update(_ button: Button, context: Context) {
        super.update(button, context: context)
        var context = context
        context.environment.foregroundColor = context.environment.accentColor
        self.label = resolver.resolve(button.label, context: context, cachedNode: self.label)
        self.label.parentNode = self
    }
    
    override func layoutSize(fitting targetSize: CGSize) -> CGSize {
        return label.layoutSize(fitting: targetSize)
    }

    override func layout(in parent: UIView, bounds: CGRect) {
        control = control ?? Control()
        control.tappedHandler = view.action
        control.frame = bounds
        parent.addSubview(control)
        label.layout(in: control, bounds: control.bounds)
    }
}
