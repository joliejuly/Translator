//
//  RouterAssembly.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation
import Swinject

class RouterAssembly: Assembly {
    private var window: UIWindow?
    private var assembly: Assembler?
    func assemble(container: Container) {
        container.register(Router.self) {
            (_, window: UIWindow, assembly: Assembler) in
                self.window = window
                self.assembly = assembly
                return Router(window, assembler: assembly)
                }.inObjectScope(.container)
        container.register(Router.self) { resolver in
            guard
                let window = self.window,
                let assembly = self.assembly,
                let router = resolver.resolve(
                    Router.self,
                    arguments: window, assembly)
                else {
                    fatalError(
                        "Inconsistent state of the app - cannot safely resolve router"
                    )
            }
            return router
            }.inObjectScope(.container)
    }
}
