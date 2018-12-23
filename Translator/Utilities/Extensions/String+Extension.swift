//
//  String+Extension.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self,
                                 comment: "")
    }
}
