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
    @IBOutlet private weak var conversationTableView: UITableView!
    
    // MARK: -LIfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: -Navigate
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // MARK: -TableView
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
        conversationTableView.register(UINib(nibName: String(describing: ConversationOutgoingMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationOutgoingMessageCell.self))
        conversationTableView.register(UINib(nibName: String(describing: ConversationIncomingMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationIncomingMessageCell.self))
        conversationTableView.rowHeight = UITableView.automaticDimension
        conversationTableView.backgroundColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        conversationTableView.separatorStyle = .none
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
