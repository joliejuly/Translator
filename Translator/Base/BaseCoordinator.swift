//
//  BaseCoordinator.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import UIKit

protocol BaseCoordinatorProtocol {
    var window: UIWindow! { get }
    init(window: UIWindow)
    func start()
}

class BaseCoordinator: NSObject, BaseCoordinatorProtocol {
    private var _window: UIWindow!
    var window: UIWindow! {
        return _window
    }
    required init(window: UIWindow) {
        _window = window
    }
    func start() {}
}
