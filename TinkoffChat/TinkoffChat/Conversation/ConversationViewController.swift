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
        conversationTableView.register(UINib(nibName: String(describing: ConversationMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationMessageCell.self))
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
        let identifier = String(describing: ConversationMessageCell.self)
        let message = dataArray.messagesData[indexPath.row]
        
        guard let cell = conversationTableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationMessageCell else { fatalError("ConversationMessageCell cannot be dequeued") }
        if indexPath.row % 2 == 0 {
            cell.messageIsIncoming = false
        } else {
            cell.messageIsIncoming = true
        }
        
        cell.configure(with: message)
        
        return cell
    }
}

// MARK: - UITableViewDataSourse
extension ConversationViewController: UITableViewDelegate {
    
}
