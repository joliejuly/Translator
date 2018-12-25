//
//  StartScreenView.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//

import UIKit
import Speech

final class StartScreenView: BaseView {
    weak var delegate: StartScreenViewDelegate?
    @IBOutlet weak var textInputView: InputView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    private var translations: [String] {
        guard let allTranslations = delegate?.translations
            else { return [] }
        return allTranslations
    }
    private var textsToTranslate: [String] {
        guard let allTexts = delegate?.textsToTranslate
            else { return [] }
        return allTexts
    }
    private var translationTypes: [TranslationType] {
        guard let allTypes = delegate?.translationTypes
            else { return [] }
        return allTypes
    }
    private let russianSpeechRecognizer = SFSpeechRecognizer(
        locale: Locale.current
    )
    private let englishSpeechRecognizer = SFSpeechRecognizer(
        locale: Locale(identifier: "en-US")
    )
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardNotifications()
        setUpTableView()
        setUpSpeechRecognizer()
        navigationController?.navigationBar.isHidden = true
        textInputView.delegate = self
        russianSpeechRecognizer?.delegate = self
        englishSpeechRecognizer?.delegate = self
    }
    
    private func setUpTableView() {
        let cell = UINib(nibName: "ChatsCell",
                         bundle: nil)
        chatTableView.register(cell,
                               forCellReuseIdentifier: "ChatsCell")
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = UITableView.automaticDimension
        chatTableView.contentInset = UIEdgeInsets(top: 0,
                                                  left: 0,
                                                  bottom: 50,
                                                  right: 0)
    }
    
    private func setUpSpeechRecognizer() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                 self.textInputView?.speechEnabled = true
            default:
                self.textInputView?.speechEnabled = false
            }
        }
    }
    
    private func setUpKeyboardNotifications() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillShow),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillHide),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
        
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        UIView.animate(withDuration: 0.4) {
            self.inputViewBottom.constant -= keyboardSize.height + 10
            self.view.layoutIfNeeded()
        }
        scrollToBottom()
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.4) {
            self.inputViewBottom.constant = -10
            self.view.layoutIfNeeded()
        }
    }
    func scrollToBottom() {
        DispatchQueue.main.async { [weak self] in
            guard
                let self = self,
                self.translations.count > 0
            else { return }
            let indexPath = IndexPath(
                row: self.translations.count - 1,
                section: 0
            )
            self.chatTableView.scrollToRow(
                at: indexPath,
                at: .bottom,
                animated: true
            )
        }
    }
}
extension StartScreenView: InputViewDelegate {
    func editingDidEnd(with text: String?,
                       and type: TranslationType) {
        guard let text = text,
            !text.isEmpty
            else { return }
        delegate?.translate(text, with: type)
    }
    func startDictation(with type: TranslationType) {
        startRecording(with: type)
    }
    func finishDictation() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}

extension StartScreenView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatsCell")
            as? ChatsCell else { return UITableViewCell() }
        let index = indexPath.row
        if index < translations.count,
           index < textsToTranslate.count,
           index < translationTypes.count {
            cell.configure(type: translationTypes[indexPath.row],
                           text: textsToTranslate[indexPath.row],
                           translation: translations[indexPath.row])
        }
        return cell
    }

}

extension StartScreenView: SFSpeechRecognizerDelegate {
    func startRecording(with type: TranslationType) {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.record,
                                                            mode: .default,
                                                            options: [])
            try AVAudioSession.sharedInstance()
                .setMode(AVAudioSession.Mode.measurement)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError(
                "Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        var speechRecognizer: SFSpeechRecognizer?
        switch type {
        case .enRu:
            speechRecognizer = englishSpeechRecognizer
        case .ruEn:
            speechRecognizer = russianSpeechRecognizer
        }
        recognitionTask = speechRecognizer?
            .recognitionTask(with: recognitionRequest,
                             resultHandler: { [weak self] result, error in
            guard let self = self else { return }
            var isFinal = false
            if result != nil {
                let text = result!.bestTranscription.formattedString
                self.delegate?.translate(text, with: type)
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0,
                             bufferSize: 1024,
                             format: recordingFormat) {
                                [weak self] buffer, when in
            self?.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {}
    }
}

