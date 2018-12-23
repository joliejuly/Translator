//
//  StartScreenAssembly.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation
import Swinject

class StartScreenAssembly: Assembly {
    func assemble(container: Container) {
        assembleStartScreen(container: container)
    }
    private func assembleStartScreen(container: Container) {
        container.register(StartScreenView.self) { resolver in
            let view =  StartScreenView()
            let presenter = StartScreenPresenter(
                view: view,
                interactor: resolver.resolve(StartScreenInteractor.self)!,
                router: resolver.resolve(Router.self)!
            )
            view.presenter = presenter
            view.delegate = presenter
            return view
            }.inObjectScope(.transient)
        container.register(StartScreenInteractor.self) { resolver in
            guard let provider = resolver.resolve(
                BaseService<TranslatorProvider>.self)
            else { fatalError() }
            let interactor = StartScreenInteractor(provider: provider)
            return interactor
            }.inObjectScope(.transient)
        container.register(BaseService<TranslatorProvider>.self) { _ in
            return BaseService<TranslatorProvider>()
        }
    }
}
