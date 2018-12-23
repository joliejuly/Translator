//
//  BaseInteractor.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation
import Moya
import RxSwift

protocol Interactor {
    associatedtype ProviderType: TargetType
    var provider: BaseService<ProviderType> { get }
    var bag: DisposeBag { get }
    init(provider: BaseService<ProviderType>)
}

class BaseInteractor<P: TargetType>: Interactor {
    private var _provider: BaseService<P>!
    private var _bag: DisposeBag = DisposeBag()
    var provider: BaseService<P> {
        return _provider
    }
    var bag: DisposeBag {
        return _bag
    }
    required init(provider: BaseService<P>) {
        _provider = provider
    }
}
