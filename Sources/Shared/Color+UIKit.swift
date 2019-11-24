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
        return UIColor(
            red: CGFloat(rgba.red),
            green: CGFloat(rgba.green),
            blue: CGFloat(rgba.blue),
            alpha: CGFloat(rgba.alpha)
        )
    }
}
