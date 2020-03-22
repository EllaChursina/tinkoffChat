//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 28.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {
    
    private static let todayDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private static let otherDayDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter
    }()
    
    private lazy var db = Firestore.firestore()
    private lazy var reference: CollectionReference = {
        guard let channelIdentifier = channelIdentifier else { fatalError() }
        print(db.collection("channels").document(channelIdentifier).documentID)
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }()
    
    private var myID = "420"
    private var myName = "Ella Chursina"
    
    var channelIdentifier: String?
    
    // MARK: -TableViewData
    fileprivate var dataArray = [Message]()
    
    // MARK: -UI
    @IBOutlet private weak var conversationTableView: UITableView!
    @IBOutlet private weak var newMessageTextField: UITextField!
    
    @IBAction private func sendNewMessage(_ sender: UIButton) {
        guard let content = newMessageTextField.text else {print("No new messages")
            return}
        
        let newMessage = Message(content: content, created: Date(), senderId: myID, senderName: myName)
        self.reference.addDocument(data: newMessage.toDict)
        
        newMessageTextField.text = ""
        
        DispatchQueue.main.async {
            self.conversationTableView.reloadData()
        }
    }
    // MARK: -LIfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = [Message]()
        
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let messages = snapshot.documents
            self?.dataArray.removeAll()
            
            for message in messages {
                let data = message.data()
                
                if let content = data["content"] as? String,
                   let senderId = data["senderID"] as? String,
                   let senderName = data["senderName"] as? String,
                   let stamp = data["created"] as? Timestamp {
                    let created = stamp.dateValue()
                    self?.dataArray.append(Message(content: content, created: created, senderId: senderId, senderName: senderName))
                } else {print("Error message data"); continue }
                
                if let messageArray = self?.dataArray {
                  self?.dataArray = messageArray.sorted(by: {$0.created < $1.created})
                }
            }
            DispatchQueue.main.async {
                self?.conversationTableView.reloadData()
            }
        }
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillSnow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        DispatchQueue.main.async {
            self.conversationTableView.reloadData()
            self.moveToLastComment()
        }
        
//        let numberOfSections = self.conversationTableView.numberOfSections
//        let numberOfRows = self.conversationTableView.numberOfRows(inSection: numberOfSections-1)
//
//        let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
//        self.conversationTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    
    //MARK: - Keyboard
    
    @objc private func keyboardWillSnow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
             let keyboardHeight = keyboardFrame.cgRectValue.height
             self.view.frame.origin.y = -keyboardHeight + 32
             print("keyboard height is:" , keyboardHeight)
           }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func moveToLastComment() {
        if self.conversationTableView.contentSize.height > self.conversationTableView.frame.height {
            let lastSectionIndex = self.conversationTableView.numberOfSections - 1
            let lastRowIndex = self.conversationTableView.numberOfRows(inSection: lastSectionIndex) - 1
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
            self.conversationTableView?.scrollToRow(at: pathToLastRow as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
        
    }
}

// MARK: - UITableViewDataSourse
extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section: \(section)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ConversationMessageCell.self)
        let message = dataArray[indexPath.row]
        
        guard let cell = conversationTableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationMessageCell else { fatalError("ConversationMessageCell cannot be dequeued") }
        if message.senderId == myID {
            cell.messageIsIncoming = false
        } else {
            cell.messageIsIncoming = true
        }

        cell.configure(with: MessageCellModel(text: message.content, name: message.senderName, date: message.created))
        
        return cell
    }
}

// MARK: - UITableViewDataSourse
extension ConversationViewController: UITableViewDelegate {
    
}
