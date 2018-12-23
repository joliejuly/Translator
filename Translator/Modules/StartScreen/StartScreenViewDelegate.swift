//
//  StartScreenViewDelegate.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation
protocol StartScreenViewDelegate: AnyObject {
    var translations: [String] { get }
    var textsToTranslate: [String] { get }
    var translationTypes: [TranslationType] { get }
    func translate(_ text: String, with type: TranslationType)
}
