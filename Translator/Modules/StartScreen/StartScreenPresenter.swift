//
//  StartScreenPresenter.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation
final class StartScreenPresenter:
BasePresenter<StartScreenView,
StartScreenInteractor,
StartScreenPresenterDelegate> {
    var translations: [String] = []
    var textsToTranslate: [String] = []
    var translationTypes: [TranslationType] = []
    var translationType: TranslationType = .enRu
    required init(view: ViewType,
                  interactor: InteractorType,
                  router: Router) {
        super.init(view: view,
                   interactor: interactor,
                   router: router)
        view.dismissKeyboardOnTap = true
    }
    
    private func getLanguages(for lang: LanguageCode) {
        interactor.getAvailableLanguages(
        for: lang) { [weak self] error, languageList in
            guard let self = self else { return }
            if let error = error {
                self.view?.onNetworkConnectionFailed(
                    error,
                    title: error.localizedDescription
                )
            } else {
               
            }
        }
    }
    
    private func detect(text: String, hint: String) {
        interactor.detect(text: text,
                          hint: hint) { [weak self] error, text in
            guard let self = self else { return }
            if let error = error {
                self.view?.onNetworkConnectionFailed(
                    error,
                    title: error.localizedDescription
                )
            } else {
                guard let detectedCode = text,
                let lang = LanguageCode(rawValue: detectedCode)
                    else { return }
                switch lang {
                case .en:
                    self.translationType = .enRu
                case .ru:
                    self.translationType = .ruEn
                }
                guard let textToTranslate = self.textsToTranslate.last
                    else { return }
                self.translationTypes.append(self.translationType)
                self.translate(text: textToTranslate,
                               lang: self.translationType.rawValue)
            }
        }
    }
    
    private func translate(text: String, lang: String) {
        interactor.translate(
            text: text,
            lang: lang) { [weak self] error, text in
            guard let self = self else { return }
            if let error = error {
                self.view?.onNetworkConnectionFailed(
                    error,
                    title: error.localizedDescription
                )
            } else {
                guard let text = text else { return }
                self.translations += text
                self.view?.chatTableView.reloadData()
                self.view?.scrollToBottom()
            }
        }
    }
}

extension StartScreenPresenter: StartScreenViewDelegate {
    func translate(_ text: String,
                   with type: TranslationType) {
        textsToTranslate.append(text)
        var hint: String
        switch type {
        case .ruEn: hint = "ru"
        case .enRu: hint = "en"
        }
        detect(text: text, hint: hint)
    }
}
