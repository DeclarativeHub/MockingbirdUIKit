//
//  TextNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class TextNode: UIKitNode<Text> {

    override var hierarchyIdentifier: String {
        return "T"
    }

    private var label: UILabel?

    override func viewDidUpdate(oldView: Text) {
        if view != oldView {
            invalidateLayout()
        }
    }

    override func layoutSize(fitting size: CGSize) -> CGSize {
        return view.storage.boundingSize(fitting: size, env: env)
    }
    
    override func layout(in parent: UIView, bounds: CGRect) {
        let label = self.label ?? UILabel()
        self.label = label
        label.frame = bounds
        parent.addSubview(label)
        label.configure(with: view.storage, env: env)
    }
}

extension UILabel {

    func configure(with storage: Text.Storage, env: EnvironmentValues) {
        font = env.font.descriptor.uiFontValue
        numberOfLines = env.lineLimit ?? 0
        minimumScaleFactor = env.minimumScaleFactor
        adjustsFontSizeToFitWidth = minimumScaleFactor != 1
        textColor = env.foregroundColor?.uiColorValue

        switch env.multilineTextAlignment {
        case .leading:
            textAlignment = .left
        case .center:
            textAlignment = .center
        case .trailing:
            textAlignment = .right
        }

        switch env.truncationMode {
        case .head:
            lineBreakMode = .byTruncatingHead
        case .middle:
            lineBreakMode = .byTruncatingMiddle
        case .tail:
            lineBreakMode = .byTruncatingTail
        }

        if storage.isAttributed {
            attributedText = storage.attributedStringValue(baseFont: env.font)
        } else {
            text = storage.stringValue
        }
    }
}
