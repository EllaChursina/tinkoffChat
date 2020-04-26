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
    
    var model: IConversationModel!
    
    // MARK: -TableViewData
    
    var channelIdentifier: String?
    var dataArray = [Message]()
    
    // MARK: -UI
    @IBOutlet weak var conversationTableView: UITableView!
    @IBOutlet weak var newMessageTextField: UITextField!
    @IBOutlet weak var sendNewMessageButton: UIButton!
    
    // MARK: -LIfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: -Loading firebase data
        dataArray = [Message]()

        syncData()
        setupTableView()
        setupNavigationBarItems()
        setupTapScreen()
        
        changeSendButton(isEnabled: true)
        
//        conversationService.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillSnow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        DispatchQueue.main.async {
            self.conversationTableView.reloadData()

        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTableView() {
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
        conversationTableView.register(UINib(nibName: String(describing: ConversationMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationMessageCell.self))
        conversationTableView.rowHeight = UITableView.automaticDimension
        conversationTableView.backgroundColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        conversationTableView.separatorStyle = .none
        upsideDownTableView()
    }
    
    private func setupNavigationBarItems(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTapScreen() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        tapScreen.delegate = self
    }
    
    private func syncData() {
        let messageReference = model.frbService.messageReferenceFor(channelIdentifier: channelIdentifier)
        model.frbService.syncConversationsData(reference: messageReference) { (dataArray) in
            self.dataArray.removeAll()
            self.dataArray = dataArray
            DispatchQueue.main.async {
                self.conversationTableView.reloadData()
            }
        }
    }
    
    
    // MARK: -Action
    @IBAction private func sendNewMessage(_ sender: UIButton) {
        
        guard let content = newMessageTextField.text else {
            performAnimation(sender, enabled: false)
            return }
        
        let messageReference = model.frbService.messageReferenceFor(channelIdentifier: channelIdentifier)
        model.frbService.addNewConversationsDocument(reference: messageReference, content: content)
        
        
        newMessageTextField.text = ""
        
        changeSendButton(isEnabled: false)
        
        
        
        DispatchQueue.main.async {
            self.conversationTableView.reloadData()
        }
    }
    
    @IBAction func textMessageDidBeginEditing(_ sender: Any) {
        changeSendButton(isEnabled: true)
    }
    
    @IBAction func textMessageDidEndEditing(_ sender: Any) {
        if newMessageTextField.text == "" {
            changeSendButton(isEnabled: false)
        } else { return }
    }
    
    func changeSendButton(isEnabled: Bool) {
        
        UIView.transition(with: sendNewMessageButton, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.sendNewMessageButton.layer.backgroundColor = isEnabled ? UIColor.green.cgColor: UIColor.lightGray.cgColor
        }, completion: { success in
            self.sendNewMessageButton.isEnabled = isEnabled
        })
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.sendNewMessageButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.5) {
                            self.sendNewMessageButton.transform = CGAffineTransform.identity
                        }
        })
    }

    
    private func performAnimation(_ button: UIButton, enabled: Bool) {
        
        if (enabled) {
            UIView.animate(withDuration: 1, animations: { () -> Void in
                button.backgroundColor = UIColor.green
            })
            
            UIView.animate(withDuration: 0.5,
                           animations: {
                            button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.5) {
                                button.transform = CGAffineTransform.identity
                            }
            })
            
        } else {
            // button shutoff
            UIView.animate(withDuration: 1, animations: { () -> Void in
                button.backgroundColor = UIColor.red
            })
            
            UIView.animate(withDuration: 0.5,
                           animations: {
                            button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.5) {
                                button.transform = CGAffineTransform.identity
                            }
            })
        }
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
    
}

// MARK: - UITableViewDataSourse
extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ConversationMessageCell.self)
        let messageModel: MessageCellModel
        guard let cell = conversationTableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationMessageCell else { fatalError("ConversationMessageCell cannot be dequeued") }
        let message = dataArray[indexPath.row]
        if message.senderId == FirebaseMessageService.myID {
            cell.messageIsIncoming = false
        } else {
            cell.messageIsIncoming = true
        }
        messageModel = MessageCellModel(text: message.content, name: message.senderName, date: message.created)
        cell.configure(with: messageModel)
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

extension ConversationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let isControllTapped = touch.view is UIControl
        return !isControllTapped
    }

}

// MARK: - IConversationServiceDelegate
//extension ConversationViewController: IConversationServiceDelegate {
//    func conversationDidUpdate(name: String?, isOnline: Bool) {
//        guard name == conversation?.name else { return }
//
//        DispatchQueue.main.async {
//            self.changeSendButton(isEnabled: isOnline)
//        }
//    }
//}
