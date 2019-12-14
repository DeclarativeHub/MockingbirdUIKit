//
//  ImageNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 23/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension Image: UIKitNodeResolvable {

    class Node: UIKitNode<Image> {

        override var hierarchyIdentifier: String {
            return "I"
        }

        private var imageView: UIImageView!

        lazy var image = UIImage(named: view.name)!

        override func layoutSize(fitting size: CGSize) -> CGSize {
            return image.size
        }

        override func layout(in parent: UIView, bounds: CGRect) {
            imageView = imageView ?? UIImageView()
            imageView.image = image
            imageView.frame = bounds
            parent.addSubview(imageView)
        }
    }
}
