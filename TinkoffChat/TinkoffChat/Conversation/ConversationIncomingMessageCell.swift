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
    @IBOutlet weak var incomingMessageLabel: UILabel!
    @IBOutlet weak var backgroundMessageView: UIView!
    
    var textForIncomingMessage: String = "" {
        didSet {
            incomingMessageLabel.text = textForIncomingMessage
            incomingMessageLabel.numberOfLines = 0
            backgroundMessageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            backgroundMessageView.layer.cornerRadius = 8
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: MessageCellModel) {
        textForIncomingMessage = model.text
    }
    
}
