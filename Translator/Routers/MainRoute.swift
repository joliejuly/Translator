//
//  MainRoute.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation
import Swinject

enum MainRoute {
    case main
}
extension MainRoute: Route {
    func config(from assembler: Assembler, with data: Any?) -> RouteConfigProtocol {
        switch self {
        case .main:
            return main(from: assembler, with: data)
        }
    }
    private func main(from assembler: Assembler, with data: Any?) -> RouteConfigProtocol {
        let view = assembler.resolver.resolve(StartScreenView.self)!
        view.presenter?.prepare(data)
        let nc = UINavigationController(rootViewController: view)
        return RouteConfig(view: nc, presentation: .changeRoot)
    }
}
