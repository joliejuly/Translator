//
//  LanguageCode.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation

enum LanguageCode: String {
    case ru = "ru"
    case en = "en"
}

enum TranslationType: String {
    case ruEn = "ru-en"
    case enRu = "en-ru"
    var reversed: TranslationType {
        switch self {
        case .ruEn: return .enRu
        case .enRu: return .ruEn
        }
    }
    var description: String {
        switch self {
        case .ruEn: return "Russian".localized
        case .enRu: return "English".localized
        }
    }
}
