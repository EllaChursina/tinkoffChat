//
//  ConversationMessageCell.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 01.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ConversationMessageCell: UITableViewCell, ConfigurableView {
    
    // MARK: -Date Formatters
    private static let todayDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private static let otherDayDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM HH:mm"
        return formatter
    }()
    
    // MARK: -UI
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var backgroundMessageView: UIView!
    @IBOutlet private weak var senderNameLabel: UILabel!
    @IBOutlet private weak var createdMessageDate: UILabel!
    
    @IBOutlet private var leftMessageConstraint: NSLayoutConstraint!
    @IBOutlet private var rightMessageConstraint: NSLayoutConstraint!
    
    var messageIsIncoming: Bool! {
        didSet {
            backgroundMessageView.backgroundColor = messageIsIncoming ? .white : UIColor(red: 255.0/255.0, green: 215.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            if messageIsIncoming {
                leftMessageConstraint.constant = 16
                rightMessageConstraint.isActive = false
                senderNameLabel.textAlignment = .left
                messageLabel.textAlignment = .left
                createdMessageDate.textAlignment = .right

            } else {
                leftMessageConstraint.isActive = false
                rightMessageConstraint.constant = 16
                senderNameLabel.textAlignment = .right
                messageLabel.textAlignment = .right
                createdMessageDate.textAlignment = .left
            }
        }
    }
    
    var date: Date? {
        didSet {
            guard let date = date else {
                createdMessageDate.text = ""
                return
            }
            if Calendar.current.isDateInToday(date) {
                createdMessageDate.text = ConversationMessageCell.todayDateFormatter.string(from: date)
            } else {
                createdMessageDate.text = ConversationMessageCell.otherDayDateFormatter.string(from: date)
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
        senderNameLabel.textAlignment = .left
        messageLabel.textAlignment = .left
        createdMessageDate.textAlignment = .right
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        senderNameLabel.text = model.name
        date = model.date
        
    }
    
}
