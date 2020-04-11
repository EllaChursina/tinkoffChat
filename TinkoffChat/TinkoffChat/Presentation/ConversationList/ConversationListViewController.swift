//
//  ConversationListViewController.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 27.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit
import Firebase

class ConversationListViewController: UIViewController {
    
    // MARK: -Firebase
    private lazy var firebaseService = FirebaseChatService.shared
    

    // MARK: -UITableViewData
    fileprivate var tableSectionTitles = ["Active", "Not Active"]
    var dataArray = [Channel?](){
        didSet {
            activeChannelsArray = dataArray.filter({ return $0?.isActive == true})
            notActiveChannelsArray = dataArray.filter({ return $0?.isActive == false})
        }
    }
    var activeChannelsArray = [Channel?]()
    var notActiveChannelsArray = [Channel?]()
    // MARK: -UI
    @IBOutlet private weak var conversationListTableView: UITableView!
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArray = [Channel?]()
        // MARK: -Loading firebase data
        firebaseService.syncConversationsData(reference: firebaseService.channelReference) { (dataArray) in
            print(dataArray)
            self.dataArray.removeAll()
            self.dataArray = dataArray
            DispatchQueue.main.async {
                self.conversationListTableView.reloadData()
            }
        }

        
        //MARK: -Navigate
        navigationItem.title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let profileItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(goToProfileViewController))
        navigationItem.leftBarButtonItem = profileItem
        
        let addNewChannelItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddingNewChannel))
        navigationItem.rightBarButtonItem = addNewChannelItem
        
        //MARK: -TableView
        conversationListTableView.dataSource = self
        conversationListTableView.delegate = self
        conversationListTableView.register(UINib(nibName: ConversationListTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: ConversationListTableViewCell.cellIdentifier)
        conversationListTableView.rowHeight = UITableView.automaticDimension
        conversationListTableView.estimatedRowHeight = 66
    }

    //MARK: -Tabbar buttons methods
    @objc private func goToProfileViewController() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            self.present(vc, animated: true, completion: nil) 
        }
    }
    
    @objc private func goToAddingNewChannel() {
        let storyboard = UIStoryboard(name: "NewChannel", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSourse
   
extension ConversationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return activeChannelsArray.count
        } else {
            return notActiveChannelsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = conversationListTableView.dequeueReusableCell(withIdentifier: ConversationListTableViewCell.cellIdentifier) as? ConversationListTableViewCell else { fatalError("ConversationListTableViewCell cannot be dequeued") }
        

        let conversation: ConversationCellModel
        let tableSection = tableSectionTitles[indexPath.section]
        let channel : Channel
        if tableSection == "Active" {
            guard let newChannel = activeChannelsArray [indexPath.row] else { return cell }
            channel = newChannel
        } else {
            guard let newChannel = notActiveChannelsArray [indexPath.row] else { return cell }
            channel = newChannel
        }
        
        conversation = ConversationCellModel(name: channel.name, message: channel.lastMessage, date: channel.lastActivity, isOnline: channel.isActive, hasUnreadMessages: false)
        cell.configure(with: conversation)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSectionTitles[section]
    }
}

// MARK: - UITableViewDelegate

extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ConversationListTableViewCell,
            let vc = UIStoryboard(name: "Conversation", bundle: nil).instantiateInitialViewController() as? ConversationViewController
            else { return }
        
        let tableSection = tableSectionTitles[indexPath.section]
        let channel : Channel
        if tableSection == "Active" {
            guard let newChannel = activeChannelsArray [indexPath.row] else { return }
            channel = newChannel
        } else {
            guard let newChannel = notActiveChannelsArray [indexPath.row] else { return }
            channel = newChannel
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = cell.name
        vc.channelIdentifier = channel.identifier
        navigationController?.pushViewController(vc, animated: true)
            
    }
}
