//
//  UIFont+Extension.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import UIKit
extension UIFont {
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)
            ?? UIFont.systemFont(ofSize: size,
                                 weight: .regular)
    }
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)
            ?? UIFont.systemFont(ofSize: size,
                                 weight: .medium)
    }
}
