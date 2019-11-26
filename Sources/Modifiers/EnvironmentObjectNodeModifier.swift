//
//  EnvironmentObjectNodeModifier.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 26/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

class EnvironmentObjectNodeModifier: UIKitNodeModifier<ViewModifiers.EnvironmentObject> {

    override var hierarchyIdentifier: String {
        return "EnvObj"
    }

    required init(_ modifier: ViewModifiers.EnvironmentObject, context: Context, resolver: UIKitNodeResolver) {
        var context = context
        context.environmentObjects[modifier.objectTypeIdentifier] = modifier.object
        super.init(modifier, context: context, resolver: resolver)
    }

    override func update(_ modifier: ViewModifiers.EnvironmentObject, context: Context) {
        var context = context
        context.environmentObjects[modifier.objectTypeIdentifier] = modifier.object
        super.update(modifier, context: context)
    }
}
