//
//  ConversationMessageCell.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 01.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ConversationMessageCell: UITableViewCell, ConfigurableView {
    
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
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var backgroundMessageView: UIView!
    @IBOutlet private weak var senderNameLabel: UILabel!
    @IBOutlet private weak var cratedMessageDate: UILabel!
    
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
    
    var date: Date? {
        didSet {
            guard let date = date else {
                cratedMessageDate.text = ""
                return
            }
            if Calendar.current.isDateInToday(date) {
                cratedMessageDate.text = ConversationMessageCell.todayDateFormatter.string(from: date)
            } else {
                cratedMessageDate.text = ConversationMessageCell.otherDayDateFormatter.string(from: date)
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
        
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        senderNameLabel.text = model.name
        date = model.date
        
    }
    
}
