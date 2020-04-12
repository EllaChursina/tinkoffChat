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
    
    private var model: NewChannelModel
    
    init(model: NewChannelModel) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -UI
    @IBOutlet weak var newChannelButton: UIButton!
    @IBOutlet weak var newChannelTextField: UITextField!
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
    }
    
    // MARK: -Action
    @IBAction func createNewChannelButton(_ sender: UIButton) {
        print("try create channel")
        guard let newChannelName = newChannelTextField.text else { errorAddingChannel()
            return
        }
        let reference = model.frbService.getChannelReference()
        model.frbService.addNewConversationsDocument(reference: reference, content: newChannelName)
        newChannelTextField.text = ""
        newChannelAddedSuccessfully()
    }
    
    // MARK: -Navigation
    @IBAction private func tapCloseButtonNewChannel (_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupStyle(){
        newChannelButton.layer.cornerRadius = 10
        newChannelButton.layer.borderWidth = 1
        newChannelButton.layer.borderColor = UIColor.black.cgColor
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
