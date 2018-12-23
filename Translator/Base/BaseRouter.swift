//
//  Router.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import UIKit
import Swinject

protocol RouterProtocol {
    var window: UIWindow { get }
    init(_ window: UIWindow, assembler: Assembler)
    func navigate(_ target: Route,
                  data: Any?,
                  in view: UIViewController?)
}

protocol Route {
    func config(from assembler: Assembler,
                with data: Any?) -> RouteConfigProtocol
}

protocol RouteConfigProtocol {
    var view: UIViewController { get }
    var presentation: PresentationType { get }
}

enum PresentationType {
    case present
    case push
    case changeRoot
}

struct RouteConfig: RouteConfigProtocol {
    let view: UIViewController
    let presentation: PresentationType
}


class Router: RouterProtocol {
    private var _window: UIWindow!
    private(set) var assembler: Assembler!
    var window: UIWindow {
        return _window
    }
    
    required init(_ window: UIWindow,
                  assembler: Assembler) {
        _window = window
        self.assembler = assembler
    }
    
    func navigate(_ route: Route,
                  data: Any?, in view: UIViewController? = nil) {
        let config = route.config(from: assembler, with: data)
        switch config.presentation {
        case .present:
            guard
                let parent = view
                else { return }
            present(config.view,
                    parent: parent)
        case .push:
            guard
                let parent = view
                else { return }
            push(config.view, parent: parent)
        case .changeRoot:
            window.rootViewController = config.view
        }
    }
        
    private func present(_ view: UIViewController,
                         parent: UIViewController) {
        DispatchQueue.main.async {
            parent.present(view, animated: true,
                           completion: nil)
        }
    }
        
    private func push(_ view: UIViewController,
                      parent: UIViewController) {
        DispatchQueue.main.async {
            parent.navigationController?
                .pushViewController(view, animated: true)
        }
    }
}
