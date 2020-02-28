//
//  ConversationListTableViewCell.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 27.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ConversationListTableViewCell: UITableViewCell, ConfigurableView {

    // MARK: -UI

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageTextLabel: UILabel!
    @IBOutlet weak var lastMessageTimeAndDateLabel: UILabel!
    @IBOutlet weak var unreadMessageIndicatorLabel: UILabel!
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var message: String? {
        didSet {
            if message != nil && !hasUnreadMessages {
                lastMessageTextLabel.font = UIFont.systemFont(ofSize: 14)
                lastMessageTextLabel.textColor = UIColor.lightGray
                lastMessageTextLabel.text = message
            } else if message != nil && hasUnreadMessages {
                lastMessageTextLabel.font = UIFont.boldSystemFont(ofSize: 14)
                lastMessageTextLabel.textColor = UIColor.lightGray
                lastMessageTextLabel.text = message
            } else {
                lastMessageTextLabel.font = UIFont(name: "Arial", size: 14)
                lastMessageTextLabel.textColor = UIColor.darkGray
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = NSCalendar.current.isDateInToday(date)
                ? "HH:mm"
                : "dd MMMM"
            lastMessageTimeAndDateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    var online: Bool = false {
       didSet {
                if online {
                    backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                } else {
                    backgroundColor = UIColor.white
                }
            }
    }
    
    var hasUnreadMessages: Bool = false {
        didSet {
            lastMessageTextLabel.font = hasUnreadMessages
                ? UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)
                : UIFont.systemFont(ofSize: nameLabel.font.pointSize)
            unreadMessageIndicatorLabel.isHidden = !hasUnreadMessages
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with model: ConversationCellModel) {
        name = model.name
        message = model.message
        date = model.date
        hasUnreadMessages = model.hasUnreadMessages
        online = model.isOnline
    }
}

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}
