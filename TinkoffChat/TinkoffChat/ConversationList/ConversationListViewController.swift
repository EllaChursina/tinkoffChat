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
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")

    // MARK: -TableViewData
    
    fileprivate var dataDictionary = [String: [Channel]]()
    fileprivate var tableSectionTitles = ["Active", "Not Active"]
    
    // MARK: -UI
    @IBOutlet private weak var conversationListTableView: UITableView!
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataDictionary = [String: [Channel]]()
        
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            let channels = snapshot.documents
            self?.dataDictionary.removeAll()
            
            for channel in channels {
                print("\(channel.data())")
                let identifier = channel.documentID
                let data = channel.data()
                
                if let name = data["name"] as? String,
                   let lastMessage = data["lastMessage"] as? String,
                   let stamp = data["lastActivity"] as? Timestamp {
                    
                    let lastActivity = stamp.dateValue()
                    let timeInterval: TimeInterval = 600.0
                    var timeInvervalLastActivity = lastActivity.timeIntervalSinceNow
                    timeInvervalLastActivity.negate()
                    
                    let channelKey:String
                    let newChannel = Channel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
                    if timeInvervalLastActivity <= timeInterval {
                        channelKey = "Active"} else {
                        channelKey = "Not Active"
                    }
                    
                    if var channelValue = self?.dataDictionary[channelKey] {
                        channelValue.append(newChannel)
                        self?.dataDictionary[channelKey] = channelValue
                    } else {
                        self?.dataDictionary[channelKey] = [newChannel]
                    }
                    
                } else {continue}
                if let activeChannelArray = self?.dataDictionary["Active"]{
                    self?.dataDictionary["Active"] = activeChannelArray.sorted(by: {$0.lastActivity > $1.lastActivity})
                }
                
                if let notActiveChannelArray = self?.dataDictionary["Not Active"]{
                    self?.dataDictionary["Not Active"] = notActiveChannelArray.sorted(by: {$0.lastActivity > $1.lastActivity})
                }
            }
            DispatchQueue.main.async {
                self?.conversationListTableView.reloadData()
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
        let channelKey = tableSectionTitles[section]
        print("\(channelKey)")
        if let channelValue = dataDictionary[channelKey] {
            print("\(channelValue)")
            return channelValue.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = conversationListTableView.dequeueReusableCell(withIdentifier: ConversationListTableViewCell.cellIdentifier) as? ConversationListTableViewCell else { fatalError("ConversationListTableViewCell cannot be dequeued") }
        
        let channelKey = tableSectionTitles[indexPath.section]
        let channel: Channel
        let conversation: ConversationCellModel
        let isActive: Bool
        
        if channelKey == "Active" {
            isActive = true
        } else {
            isActive = false
        }
        
        if let dictionaryByKey = dataDictionary[channelKey] {
            channel = dictionaryByKey[indexPath.row]
            conversation = ConversationCellModel(name: channel.name, message: channel.lastMessage, date: channel.lastActivity, isOnline: isActive, hasUnreadMessages: false)
            cell.configure(with: conversation)
            
            return cell
        } else {
            print("Error")
        }
        
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
        
        let channelKey = tableSectionTitles[indexPath.section]
        let channel: Channel
        
        if let dictionaryByKey = dataDictionary[channelKey] {
            channel = dictionaryByKey[indexPath.row]
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = cell.name
            vc.channelIdentifier = channel.identifier
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            print("Error")
        }
    }
}
