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
    @IBOutlet weak var outgoingMessageLabel: UILabel!
    @IBOutlet weak var backgroundMessageView: UIView!
    
    var textForOutgoingMessage: String = "" {
        didSet {
            outgoingMessageLabel.text = textForOutgoingMessage
            outgoingMessageLabel.numberOfLines = 0
            backgroundMessageView.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
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
        textForOutgoingMessage = model.text
    }
    
}
