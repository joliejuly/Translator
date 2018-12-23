//
//  BaseProvider.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import Foundation
import Alamofire
import Moya

class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 90
        configuration.timeoutIntervalForResource = 90
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.httpAdditionalHeaders = [
            "Accept": "*/*",
            "Content-type": "application/x-www-form-urlencoded"
        ]
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

extension TargetType {
    var baseURL: URL {
        guard let url = URL(
                string: "https://translate.yandex.net/api/v1.5/tr.json/"
            )
        else { fatalError("Base API URL is no longer valid") }
        return url
    }
    var headers: [String: String]? {
        return nil
    }
    var validationType: ValidationType {
        return .none
    }
}

class BaseService<Target: TargetType>: MoyaProvider<Target> {
    override init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        callbackQueue: DispatchQueue? = nil,
        manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
        plugins: [PluginType] = [],
        trackInflights: Bool = false) {
        var plgs = plugins
        #if DEBUG
        plgs.append(NetworkLoggerPlugin(verbose: true))
        #endif
        super.init(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            callbackQueue: callbackQueue,
            manager: DefaultAlamofireManager.sharedManager,
            plugins: plgs,
            trackInflights: trackInflights)
    }
}
