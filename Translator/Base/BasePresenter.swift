//
//  BasePresenter.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import UIKit

protocol AbstractPresenter: class {
    var router: Router { get }
    func prepare(_ data: Any?)
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
    func registerDelegate<T>(_ delegate: T)
}

protocol Presenter: class {
    associatedtype ViewType
    associatedtype InteractorType
    associatedtype Delegate
    var view: ViewType? {get}
    var interactor: InteractorType {get}
    var delegate: Delegate? { get set }
    init(view: ViewType, interactor: InteractorType, router: Router)
}

class BasePresenter<V: BaseView, I: Interactor, Delegate: AnyObject>: Presenter, AbstractPresenter {
    private weak var _view: V?
    weak var delegate: Delegate?
    private var _interactor: I!
    private var _data: Any?
    private var _router: Router!
    var view: V? {
        return _view
    }
    var interactor: I {
        return _interactor
    }
    var router: Router {
        return _router
    }
    required init(view: V, interactor: I, router: Router) {
        _view = view
        _interactor = interactor
        _router = router
    }
    func registerDelegate<T>(_ delegate: T) {
        self.delegate = delegate as? Delegate
    }
    func prepare(_ data: Any?) {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
}
