//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 28.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    // MARK: -TableViewData
    fileprivate var dataArray = MessageDataModel()
    
    // MARK: -UI
    @IBOutlet weak var conversationTableView: UITableView!
    
    // MARK: -LIfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: -Navigate
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // MARK: -TableView
        self.conversationTableView.delegate = self
        self.conversationTableView.dataSource = self
        self.conversationTableView.register(UINib(nibName: String(describing: ConversationOutgoingMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationOutgoingMessageCell.self))
        self.conversationTableView.register(UINib(nibName: String(describing: ConversationIncomingMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationIncomingMessageCell.self))
        self.conversationTableView.rowHeight = UITableView.automaticDimension
        self.conversationTableView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        self.conversationTableView.separatorStyle = .none
    }
}

// MARK: - UITableViewDataSourse
extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.messagesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String
        let message = dataArray.messagesData[indexPath.row]
        if indexPath.row % 2 == 0 {
            identifier = String(describing: ConversationIncomingMessageCell.self)
            guard let cell = conversationTableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationIncomingMessageCell else { fatalError("ConversationIncomingMessageCell cannot be dequeued") }
            cell.configure(with: message)
            return cell
        } else {
            
            identifier = String(describing: ConversationOutgoingMessageCell.self)
            guard let cell = conversationTableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationOutgoingMessageCell else { fatalError("ConversationOutgoingMessageCell cannot be dequeued") }
            cell.configure(with: message)
            return cell
        }
    }
}

// MARK: - UITableViewDataSourse
extension ConversationViewController: UITableViewDelegate {
    
}
