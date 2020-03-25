//
//  NewChannelViewController.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 21.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit
import Firebase

class NewChannelViewController: UIViewController {
    
    // MARK: -Firebase
    private lazy var firebaseService = FirebaseChatService.shared
    private lazy var conversationProtocol: ConversationDataProviderProtocol = firebaseService
    
    // MARK: -UI
    @IBOutlet weak var newChannelButton: UIButton!
    @IBOutlet weak var newChannelTextField: UITextField!
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newChannelButton.layer.cornerRadius = 10
        newChannelButton.layer.borderWidth = 1
        newChannelButton.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: -Action
    @IBAction func createNewChannelButton(_ sender: UIButton) {
        print("try create channel")
        conversationProtocol.addNewConversationsDocument(reference: firebaseService.channelReference, viewController: self)
    }
    
    // MARK: -Navigation
    @IBAction private func tapCloseButtonNewChannel (_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
