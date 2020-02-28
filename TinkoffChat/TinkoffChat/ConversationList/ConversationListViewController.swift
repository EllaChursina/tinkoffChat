//
//  ConversationListViewController.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 27.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ConversationListViewController: UIViewController {
    
    // MARK: -Table
    var dataArray = ConversationDataModel()
    var tableSectionName = ["Online", "History"]
    
    // MARK: -UI
    @IBOutlet weak var conversationListTableView: UITableView!
    
    // MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.conversationListTableView.dataSource = self
        self.conversationListTableView.delegate = self
        self.conversationListTableView.register(UINib(nibName: String(describing: ConversationListTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationListTableViewCell.self))
        self.conversationListTableView.rowHeight = UITableView.automaticDimension
        self.conversationListTableView.estimatedRowHeight = 66
    }
    

}



// MARK: - UITableViewDataSourse
   
extension ConversationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSectionName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ConversationListTableViewCell.self)
        guard let cell = conversationListTableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationListTableViewCell else { fatalError("ConversationListTableViewCell cannot be dequeued") }
        let tableSection = tableSectionName[indexPath.section]
        let conversation: ConversationCellModel
        if tableSection == "Online" {
            conversation = dataArray.onlineConversations[indexPath.row]
        } else {
            conversation = dataArray.offlineConversations[indexPath.row]
        }
        cell.configure(with: conversation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSectionName[section]
    }
}

// MARK: - UITableViewDataSourse

extension ConversationListViewController: UITableViewDelegate {
    
}
