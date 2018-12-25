//
//  SpeakersView.swift
//  Translator
//
//  Created by Julia Nikitina on 25/12/2018.
//

import UIKit

class SpeakersView: UIView {

    weak var delegate: SpeakersViewDelegate?
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var firstSpeaker: UIImageView!
    @IBOutlet weak var secondSpeaker: UIImageView!
    @IBOutlet weak var thirdSpeaker: UIImageView!
    @IBOutlet weak var fourthSpeaker: UIImageView!
    @IBOutlet weak var fifthSpeaker: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        Bundle.main.loadNibNamed("SpeakersView",
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
        contentView.backgroundColor = .clear
        addGestureRecognizer()
    }
    
    private func addGestureRecognizer() {
        contentView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(stopRecording)
        )
      )
    }
    
    @objc func stopRecording() {
        delegate?.stopRecording()
    }
    
    func animate() {
        let keyframes = { [weak self] in
            guard let self = self else { return }
            let edgeSpeakers = [self.firstSpeaker,
                                self.fifthSpeaker]
            let middleSpeakers = [self.secondSpeaker,
                                  self.fourthSpeaker]
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 0.25) {
                edgeSpeakers.forEach {
                    $0?.transform = CGAffineTransform(scaleX: 1, y: 1.5)
                }
                middleSpeakers.forEach {
                    $0?.transform = CGAffineTransform(scaleX: 1, y: 1.5)
                }
                self.thirdSpeaker.transform = CGAffineTransform(scaleX: 1, y: 0.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25,
                               relativeDuration: 0.25) {
                edgeSpeakers.forEach {
                    $0?.transform = CGAffineTransform(scaleX: 1, y: 0.5)
                }
                middleSpeakers.forEach {
                    $0?.transform = CGAffineTransform(scaleX: 1, y: 0.5)
                }
                self.thirdSpeaker.transform = CGAffineTransform(scaleX: 1, y: 0.5)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5,
                               relativeDuration: 0.25) {
                edgeSpeakers.forEach {
                    $0?.transform = CGAffineTransform(scaleX: 1, y: 0.7)
                }
                middleSpeakers.forEach {
                    $0?.transform = CGAffineTransform(scaleX: 1, y: 0.7)
                }
                self.thirdSpeaker.transform = CGAffineTransform(scaleX: 1, y: 0.7)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.75,
                               relativeDuration: 0.25) {
                edgeSpeakers.forEach {
                    $0?.transform = .identity
                }
                middleSpeakers.forEach {
                    $0?.transform = .identity
                }
                self.thirdSpeaker.transform = .identity
            }
        }
        
        UIView.animateKeyframes(withDuration: 2,
                                delay: 0,
                                options: [.calculationModeCubic,
                                          .repeat,
                                          .autoreverse],
                                animations: keyframes)
    }
}
