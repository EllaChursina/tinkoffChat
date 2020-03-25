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
    
    
    // MARK: -Firebase
    private lazy var firebaseService = FirebaseMessageService.shared
    private lazy var conversationProtocol: ConversationDataProviderProtocol = firebaseService
    private lazy var messageReference = firebaseService.messageReferenceFor(channelIdentifier: channelIdentifier)
    
    // MARK: -TableViewData
    var channelIdentifier: String?
    var dataArray = [Message]()
    
    // MARK: -UI
    @IBOutlet weak var conversationTableView: UITableView!
    @IBOutlet weak var newMessageTextField: UITextField!
    
    
    // MARK: -LIfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: -Loading firebase data
        dataArray = [Message]()
        conversationProtocol.syncConversationsData(reference: messageReference, viewController: self, tableView: conversationTableView)
        
        // MARK: -Navigate
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // MARK: -TableView
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
        conversationTableView.register(UINib(nibName: String(describing: ConversationMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationMessageCell.self))
        conversationTableView.rowHeight = UITableView.automaticDimension
        conversationTableView.backgroundColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        conversationTableView.separatorStyle = .none
        upsideDownTableView()
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillSnow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        DispatchQueue.main.async {
            self.conversationTableView.reloadData()
//            self.conversationTableView.moveToLastComment()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: -Action
    @IBAction private func sendNewMessage(_ sender: UIButton) {
        conversationProtocol.addNewConversationsDocument(reference: messageReference, viewController: self)
    }
    
    //MARK: - Keyboard
    @objc private func keyboardWillSnow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight + 32
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    @objc private func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UITableViewDataSourse
extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ConversationMessageCell.self)
        let message = dataArray[indexPath.row]
        
        guard let cell = conversationTableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationMessageCell else { fatalError("ConversationMessageCell cannot be dequeued") }
        if message.senderId == FirebaseMessageService.myID {
            cell.messageIsIncoming = false
        } else {
            cell.messageIsIncoming = true
        }
        
        cell.configure(with: MessageCellModel(text: message.content, name: message.senderName, date: message.created))
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
    
    func upsideDownTableView() {
        conversationTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
}

// MARK: - UITableViewDataSourse
extension ConversationViewController: UITableViewDelegate {
    
}

