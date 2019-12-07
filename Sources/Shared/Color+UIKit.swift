//
//  Color+UIKit.swift
//  Mockingbird
//
//  Created by Srdan Rasic on 15/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

extension Color {

    var uiColorValue: UIColor {
        switch storage {
        case .rgba(let red, let green, let blue, let alpha):
            return UIColor(
                red: CGFloat(red),
                green: CGFloat(green),
                blue: CGFloat(blue),
                alpha: CGFloat(alpha)
            )
        case .asset(let name, let bundle):
            if #available(iOS 11.0, *) {
                return UIColor(named: name, in: bundle, compatibleWith: nil)!
            } else {
                fatalError("Color assets are not available on iOS 10 or earlier.")
            }
        }
    }
}
