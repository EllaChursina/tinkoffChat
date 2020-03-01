//
//  ConversationMessageCell.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 01.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ConversationMessageCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var backgroundMessageView: UIView!
    
    @IBOutlet private weak var leftMessageConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rightMessageConstraint: NSLayoutConstraint!
    
    var messageIsIncoming: Bool = true {
        didSet {
            if messageIsIncoming {
                backgroundMessageView.backgroundColor = UIColor.white
                leftMessageConstraint.constant = 8
                rightMessageConstraint.isActive = false
            } else {
                backgroundMessageView.backgroundColor = UIColor(red: 255.0/255.0, green: 215.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                leftMessageConstraint.isActive = false
                rightMessageConstraint.constant = 8
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundMessageView.backgroundColor = UIColor(red: 255.0/255.0, green: 215.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        backgroundMessageView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
       messageLabel.text = ""
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
    }
    
}
