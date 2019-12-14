//
//  SpacerNode.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 10/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension Spacer: UIKitNodeResolvable {

    class Node: UIKitNode<Spacer> {

        override var hierarchyIdentifier: String {
            return "-"
        }

        var minLenght: CGFloat {
            return view.minLength ?? env.stackSpacing
        }

        override func isSpacer() -> Bool {
            return true
        }

        override func layoutSize(fitting targetSize: CGSize) -> CGSize {
            switch env._layoutAxis {
            case .horizontal:
                return CGSize(width: minLenght, height: 0)
            case .vertical:
                return CGSize(width: 0, height: minLenght)
            default:
                return max(CGSize(width: minLenght, height: minLenght), targetSize)
            }
        }
    }
}
