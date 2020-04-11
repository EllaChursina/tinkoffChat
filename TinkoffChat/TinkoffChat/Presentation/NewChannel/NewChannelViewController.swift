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
        guard let newChannelName = newChannelTextField.text else { errorAddingChannel()
            return
        }
        firebaseService.addNewConversationsDocument(reference: firebaseService.channelReference, content: newChannelName)
        newChannelTextField.text = ""
        newChannelAddedSuccessfully()
    }
    
    // MARK: -Navigation
    @IBAction private func tapCloseButtonNewChannel (_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func errorAddingChannel() {
        let alertController = UIAlertController(title: "Error", message: "Error adding the new channel", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true)
    }
    
    func newChannelAddedSuccessfully(){
        let alertController = UIAlertController(title: "The new channel added to TinkoffChat successfully", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true)
        
    }
    
}
