//
//  InputViewDelegate.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation
protocol InputViewDelegate: AnyObject {
    func editingDidEnd(with: String?,
                       and type: TranslationType)
    func startDictation(with: TranslationType)
    func finishDictation()
}
