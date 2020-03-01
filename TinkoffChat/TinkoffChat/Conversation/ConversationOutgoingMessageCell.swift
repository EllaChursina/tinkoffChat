//
//  ConversationOutgoingMessageCell.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 28.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ConversationOutgoingMessageCell: UITableViewCell, ConfigurableView {
    
    // MARK: -UI
    @IBOutlet private weak var outgoingMessageLabel: UILabel!
    @IBOutlet private weak var backgroundMessageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundMessageView.backgroundColor = UIColor(red: 255.0/255.0, green: 215.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        backgroundMessageView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with model: MessageCellModel) {
        outgoingMessageLabel.text = model.text
    }
    
}
