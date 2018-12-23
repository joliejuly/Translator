//
//  AppCoordinator.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import UIKit
import Swinject
import RxSwift

class AppCoordinator: BaseCoordinator {
    private var bag = DisposeBag()
    private var assembler = Assembler([
        RouterAssembly(),
        StartScreenAssembly()
        ])
    private var router: Router?
    required init(window: UIWindow) {
        super.init(window: window)
    }
    override func start() {
        guard
            let window = window,
            let router =
            assembler.resolver.resolve(Router.self,
                                       arguments: window,
                                       assembler)
            else { return }
        router.navigate(MainRoute.main, data: nil)
        window.makeKeyAndVisible()
    }
}
