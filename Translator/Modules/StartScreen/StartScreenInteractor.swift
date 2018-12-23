//
//  StartScreenInteractor.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation
import Moya
import RxSwift

final class StartScreenInteractor: BaseInteractor<TranslatorProvider> {
    func getAvailableLanguages(
        for lang: LanguageCode,
        completion: @escaping (Error?, LanguageList?) -> Void) {
        provider
            .rx
            .request(
                .languages(code: lang)
            )
            .subscribeOn(
                ConcurrentDispatchQueueScheduler
                    .init(qos: .utility)
            )
            .observeOn(MainScheduler.asyncInstance)
            .map(LanguageList.self)
            .subscribe { event in
                switch event {
                case .error(let error):
                    completion(error, nil)
                case .success(let languages):
                    completion(nil, languages)
                }
            }
            .disposed(by: bag)
    }
    func detect(
        text: String,
        hint: String,
        completion: @escaping (Error?, String?) -> Void) {
        provider
            .rx
            .request(
                .detectLanguage(text: text, hint: hint)
            )
            .subscribeOn(
                ConcurrentDispatchQueueScheduler
                    .init(qos: .utility)
            )
            .observeOn(MainScheduler.asyncInstance)
            .map(String.self, atKeyPath: "lang")
            .subscribe { event in
                switch event {
                case .error(let error):
                    completion(error, nil)
                case .success(let lang):
                    completion(nil, lang)
                }
            }
            .disposed(by: bag)
    }
    func translate(
        text: String,
        lang: String,
        completion: @escaping (Error?, [String]?) -> Void) {
        provider
            .rx
            .request(
                .translate(text: text, lang: lang)
            )
            .subscribeOn(
                ConcurrentDispatchQueueScheduler
                    .init(qos: .utility)
            )
            .observeOn(MainScheduler.asyncInstance)
            .map([String].self, atKeyPath: "text")
            .subscribe { event in
                switch event {
                case .error(let error):
                    completion(error, nil)
                case .success(let translatedText):
                    completion(nil, translatedText)
                }
            }
            .disposed(by: bag)
    }
}
