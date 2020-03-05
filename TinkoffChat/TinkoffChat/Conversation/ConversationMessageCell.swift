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
    
    @IBOutlet private var leftMessageConstraint: NSLayoutConstraint!
    @IBOutlet private var rightMessageConstraint: NSLayoutConstraint!
    
    var messageIsIncoming: Bool! {
        didSet {
            backgroundMessageView.backgroundColor = messageIsIncoming ? .white : UIColor(red: 255.0/255.0, green: 215.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            if messageIsIncoming {
                leftMessageConstraint.constant = 16
                rightMessageConstraint.isActive = false
            } else {
                leftMessageConstraint.isActive = false
                rightMessageConstraint.constant = 16
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundMessageView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        messageLabel.text = ""
        leftMessageConstraint.isActive = true
        rightMessageConstraint.isActive = true 
        print("prepareForReuse")
        
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
    }
    
}
