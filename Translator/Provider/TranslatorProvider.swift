//
//  TranslatorProvider.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Moya
enum TranslatorProvider {
    case languages(code: LanguageCode)
    case detectLanguage(text: String, hint: String)
    case translate(text: String, lang: String)
}
extension TranslatorProvider: TargetType {
    private var apiKey: String {
        return "trnsl.1.1.20181223T114229Z.2ccaadc1d3213b72.ad69bd08f24894091a5b20f018897d24332d2dac"
    }
    var path: String {
        switch self {
        case .languages:
            return "getLangs"
        case .detectLanguage:
            return "detect"
        case .translate:
            return "translate"
        }
    }
    var method: Moya.Method {
        return .post
    }
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case let .languages(code):
            return .requestParameters(
                parameters: [
                    "ui": code.rawValue,
                    "key": apiKey
                ],
                encoding: URLEncoding.queryString)
        case let .detectLanguage(text, hint):
            return .requestParameters(
                parameters: [
                    "text": text,
                    "hint": hint,
                    "key": apiKey
                ],
                encoding: URLEncoding.queryString)
        case let .translate(text, lang):
            return .requestParameters(
                parameters: [
                    "text": text,
                    "lang": lang,
                    "key": apiKey
                ],
                encoding: URLEncoding.queryString)
        }
    }
}

