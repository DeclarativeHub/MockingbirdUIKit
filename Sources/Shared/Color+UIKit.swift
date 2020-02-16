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

    var cgColorValue: CGColor {
        return uiColorValue.cgColor
    }
}
