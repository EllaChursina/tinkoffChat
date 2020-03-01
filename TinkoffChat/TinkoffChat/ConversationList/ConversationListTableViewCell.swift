//
//  ConversationListTableViewCell.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 27.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ConversationListTableViewCell: UITableViewCell, ConfigurableView {
    
    static let identifier = String(describing: ConversationListTableViewCell.self)
    static let todayDateFormatter = DateFormatter()
    static let otherDayDateFormatter = DateFormatter()
    

    // MARK: -UI

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastMessageTextLabel: UILabel!
    @IBOutlet private weak var lastMessageTimeAndDateLabel: UILabel!
    @IBOutlet private weak var unreadMessageIndicatorLabel: UILabel!
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var message: String? {
        didSet {
            if let message = message {
                lastMessageTextLabel.text = message
            } else {
                lastMessageTextLabel.font = UIFont(name: "Arial", size: 15)
                lastMessageTextLabel.textColor = UIColor.lightGray
                lastMessageTextLabel.text = "No messages yet"
            }
        }
    }
    
    var date: Date? {
        didSet {
            guard let date = date else {
                lastMessageTimeAndDateLabel.text = ""
                return
            }
            ConversationListTableViewCell.todayDateFormatter.dateFormat = "HH:mm"
            ConversationListTableViewCell.otherDayDateFormatter.dateFormat = "dd MMMM"
            if NSCalendar.current.isDateInToday(date) {
                lastMessageTimeAndDateLabel.text = ConversationListTableViewCell.todayDateFormatter.string(from: date)
            } else {
                lastMessageTimeAndDateLabel.text = ConversationListTableViewCell.otherDayDateFormatter.string(from: date)
            }
        }
    }
    
    var online: Bool = false {
       didSet {
            if online {
                backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 210.0/255.0, alpha: 1.0)
            } else {
                backgroundColor = UIColor.white
            }
        }
    }
    
    var hasUnreadMessages: Bool = false {
        didSet {
            if message == nil {
                unreadMessageIndicatorLabel.isHidden = true
                lastMessageTimeAndDateLabel.isHidden = true 
            } else {
                lastMessageTextLabel.font = hasUnreadMessages
                    ? UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)
                    : UIFont.systemFont(ofSize: nameLabel.font.pointSize)
                unreadMessageIndicatorLabel.isHidden = !hasUnreadMessages
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        lastMessageTextLabel.font = UIFont.systemFont(ofSize: nameLabel.font.pointSize)
        lastMessageTextLabel.textColor = UIColor.gray
    }

    func configure(with model: ConversationCellModel) {
        name = model.name
        message = model.message
        date = model.date
        hasUnreadMessages = model.hasUnreadMessages
        online = model.isOnline
    }
}


