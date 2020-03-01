//
//  ConversationIncomingMessageCell.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 28.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ConversationIncomingMessageCell: UITableViewCell, ConfigurableView {

    // MARK: -UI
    @IBOutlet private weak var incomingMessageLabel: UILabel!
    @IBOutlet private weak var backgroundMessageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundMessageView.backgroundColor = .white
        backgroundMessageView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: MessageCellModel) {
        incomingMessageLabel.text = model.text
    }
}
