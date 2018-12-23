//
//  InputView.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//  Copyright © 2018 ATON_MACBOOK. All rights reserved.
//

import UIKit

final class InputView: UIView {
    private enum ButtonState: String {
        case microphone
        case close
        case enterText
        case speakers
        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }
    }
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var firstLangButton: UIButton!
    @IBOutlet weak var secondLangButton: UIButton!
    weak var delegate: InputViewDelegate?
    var speechEnabled = false
    private var translationType: TranslationType = .enRu
    private var currentButtonState: ButtonState = .microphone
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        actionButton.setImage(
            ButtonState.microphone.image,
            for: .normal)
        currentButtonState = .microphone
        sender.text = ""
        updatePlaceholder()
    }
    
    @IBAction func didEndOnExit(_ sender: UITextField) {
        endEditing()
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        actionButton.setImage(
            ButtonState.enterText.image,
            for: .normal)
        currentButtonState = .enterText
    }
    
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        switch currentButtonState {
        case .microphone:
            guard speechEnabled else {
                editingDidEnd(textField)
                return
            }
            actionButton.setImage(
                ButtonState.speakers.image,
                for: .normal)
            currentButtonState = .speakers
            textField.attributedPlaceholder =
            NSAttributedString(string: "Speak".localized,
                               attributes:
                [.foregroundColor: UIColor.lightGray,
                 .font: UIFont.medium(size: 17)]
            )
            textField.resignFirstResponder()
            delegate?.startDictation(with: translationType)
        case .enterText:
            endEditing()
        case .speakers:
            delegate?.finishDictation()
            editingDidEnd(textField)
        default: return
        }
    }
    
    @IBAction func langButtonClicked(_ sender: Any) {
        translationType = translationType.reversed
        UIView.animate(withDuration: 0.3) {
            self.contentView.backgroundColor = self.translationType == .ruEn ? .translateRed : .translateBlue
        }
        let firstImage = self.secondLangButton.image(
            for: .normal)
        let secondImage = self.firstLangButton.image(
            for: .normal)
        self.firstLangButton.setImage(firstImage,
                                      for: .normal)
        self.secondLangButton.setImage(secondImage,
                                       for: .normal)
        updatePlaceholder()
    }
    private func updatePlaceholder() {
        textField.attributedPlaceholder =
            NSAttributedString(
                string: translationType.description,
                attributes: [.foregroundColor: UIColor.lightGray,
                             .font: UIFont.medium(size: 17)])
    }
    private func endEditing() {
        delegate?.editingDidEnd(with: textField.text,
                                and: translationType)
        actionButton.setImage(
            ButtonState.microphone.image,
            for: .normal)
        currentButtonState = .microphone
        textField.text = ""
        updatePlaceholder()
    }
    private func setUp() {
        Bundle.main.loadNibNamed("InputView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView
            .translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor
                .constraint(equalTo: topAnchor),
            contentView.bottomAnchor
                .constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor
                .constraint(equalTo: trailingAnchor),
            contentView.leadingAnchor
                .constraint(equalTo: leadingAnchor)
          ]
        )
        let cornerRadius: CGFloat = 30
        contentView.layer.cornerRadius =
            cornerRadius
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .translateBlue
        updatePlaceholder()
        textField.font = UIFont.medium(size: 17)
    }
}
