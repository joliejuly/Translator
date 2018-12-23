//
//  BaseView.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.

import UIKit
import Moya

protocol BaseViewProtocol: class {
    associatedtype Presenter
    var presenter: Presenter? { get set}
    var isVisible: Bool { get }
    var dismissKeyboardOnTap: Bool { get }
    func onNetworkConnectionFailed(_ error: Error)
    func onNetworkConnectionFailed(_ error: Error, title: String)
}

class BaseView: UIViewController, BaseViewProtocol {
    private var hasAlreadyShownAlert = false
    var presenter: AbstractPresenter?
    var isVisible = false
    var dismissKeyboardOnTap = false
    
    override var supportedInterfaceOrientations:
        UIInterfaceOrientationMask {
        return .portrait
    }
    
    var topMostController: UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dismissKeyboardOnTap {
            setupKeyboardDismissing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
        presenter?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isVisible = false
        presenter?.viewDidDisappear()
    }
    
    func onNetworkConnectionFailed(_ error: Error) {
        showNetworkError(error)
    }
    func onNetworkConnectionFailed(_ error: Error, title: String) {
        showNetworkError(error, title: title)
    }
    
    private func setupKeyboardDismissing() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(false)
    }
    private func showNetworkError(_ error: Error,
                                  title: String? = nil) {
        if let err = error as? MoyaError,
            let msg = err.errorDescription {
            showError(msg, title: title)
        } else {
            showError(
                "UnknownError".localized,
                title: title)
        }
    }
    private func showError(_ msg: String,
                           title: String? = nil) {
        if hasAlreadyShownAlert {
            return
        }
        hasAlreadyShownAlert = true
        let alert = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Ok".localized,
            style: .cancel,
            handler: { _ in
                self.hasAlreadyShownAlert = false
        })
        alert.addAction(action)
        DispatchQueue.main
            .asyncAfter(deadline: DispatchTime.now() + 0.3) {
                [weak self] in
                self?.topMostController?
                         .present(alert,
                                  animated: true,
                                  completion: nil)
        }
    }
}
