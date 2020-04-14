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
    
    var model : IConversationListModel!
    var presentationAssembly: IPresentationAssembly!
    
    // MARK: -UITableViewData
    fileprivate var tableSectionTitles = ["Active", "Not Active"]
    var dataArray = [Channel](){
        didSet {
            activeChannelsArray = dataArray.filter({ return $0.isActive == true})
             let sortedActiveArray = activeChannelsArray.sorted(by: {$0.lastActivity > $1.lastActivity})
            activeChannelsArray = sortedActiveArray
            
            notActiveChannelsArray = dataArray.filter({ return $0.isActive == false})
            let sortedNotActiveArray = notActiveChannelsArray.sorted(by: {$0.lastActivity > $1.lastActivity})
            notActiveChannelsArray = sortedNotActiveArray
        }
    }
    var activeChannelsArray = [Channel]()
    var notActiveChannelsArray = [Channel]()
    
    // MARK: -UI
    @IBOutlet private weak var conversationListTableView: UITableView!
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = [Channel]()
        
        setupTableView()
        syncData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      setupNavigationBarItems()

    }


    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(true)

    }
    
    private func setupTableView() {
        conversationListTableView.dataSource = self
        conversationListTableView.delegate = self
        conversationListTableView.register(UINib(nibName: ConversationListTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: ConversationListTableViewCell.cellIdentifier)
        conversationListTableView.rowHeight = UITableView.automaticDimension
        conversationListTableView.estimatedRowHeight = 66
    }
    
    private func setupNavigationBarItems(){
        navigationItem.title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let profileItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(goToProfileViewController))
        navigationItem.leftBarButtonItem = profileItem
        
        let addNewChannelItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddingNewChannel))
        navigationItem.rightBarButtonItem = addNewChannelItem
    }
    
    private func syncData() {
        let reference = model.frbService.getChannelReference()
        model.frbService.syncConversationsData(reference: reference) { (dataArray) in
            print(dataArray)
            self.dataArray.removeAll()
            self.dataArray = dataArray
            DispatchQueue.main.async {
                self.conversationListTableView.reloadData()
            }
        }
    }

    //MARK: -Tabbar buttons methods
    @objc private func goToProfileViewController() {
        let vc = presentationAssembly.profileViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func goToAddingNewChannel() {
        let vc = presentationAssembly.newChannelViewController()
        self.present(vc, animated: true, completion: nil)
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
            let newChannel = activeChannelsArray [indexPath.row]
            channel = newChannel
        } else {
            let newChannel = notActiveChannelsArray [indexPath.row]
            channel = newChannel
        }
        
        conversation = ConversationCellModel(name: channel.name,
                                             message: channel.lastMessage,
                                             date: channel.lastActivity,
                                             isOnline: channel.isActive,
                                             hasUnreadMessages: false)
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
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ConversationListTableViewCell
            
            else { return }
        
        let vc = presentationAssembly.conversationViewController()
        
        let tableSection = tableSectionTitles[indexPath.section]
        let channel : Channel
        
        if tableSection == "Active" {
            let newChannel = activeChannelsArray [indexPath.row]
            channel = newChannel
        } else {
            let newChannel = notActiveChannelsArray [indexPath.row]
            channel = newChannel
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = cell.name
        vc.channelIdentifier = channel.identifier
        navigationController?.pushViewController(vc, animated: true)
            
    }
}
