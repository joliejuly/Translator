//
//  ChatsCell.swift
//  Translator
//
//  Created by Julia Nikitina on 23/12/2018.
//  Copyright © 2018 ATON_MACBOOK. All rights reserved.
//

import UIKit

enum ChatCellType {
    case red
    case blue
}

class ChatsCell: UITableViewCell {

    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var redViewSubtitle: UILabel!
    @IBOutlet weak var redViewTitle: UILabel!
    @IBOutlet weak var blueViewTitle: UILabel!
    @IBOutlet weak var blueViewSubtitle: UILabel!
    var type = TranslationType.enRu
    private var cornerRadius: CGFloat = 20
    override func awakeFromNib() {
        super.awakeFromNib()
        redView.backgroundColor = .translateRed
        blueView.backgroundColor = .translateBlue
        redView.isHidden = true
        blueView.isHidden = true
        redView.layer.cornerRadius = cornerRadius
        redView.layer.maskedCorners = [.layerMinXMaxYCorner,
                                       .layerMaxXMinYCorner,
                                       .layerMinXMinYCorner]
        blueView.layer.cornerRadius = cornerRadius
        blueView.layer.maskedCorners = [.layerMinXMinYCorner,
                                       .layerMaxXMinYCorner,
                                       .layerMaxXMaxYCorner]
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        redView.isHidden = true
        blueView.isHidden = true
        redViewTitle.text = ""
        blueViewTitle.text = ""
        redViewSubtitle.text = ""
        blueViewSubtitle.text = ""
    }

    func configure(type: TranslationType,
                   text: String,
                   translation: String) {
        switch type {
        case .ruEn:
            redViewTitle.text = translation
            redViewSubtitle.text = text
            redView.isHidden = false
        case .enRu:
            blueViewTitle.text = translation
            blueViewSubtitle.text = text
            blueView.isHidden = false
        }
    }
}
