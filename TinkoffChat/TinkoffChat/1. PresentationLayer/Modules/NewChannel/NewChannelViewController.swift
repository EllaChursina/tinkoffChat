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
    
    var model: INewChannelModel!
    
    // MARK: -UI
    @IBOutlet weak var newChannelButton: UIButton!
    @IBOutlet weak var newChannelTextField: UITextField!
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationBar()
        setupStyle()
    }
    
    private func addNavigationBar(){
        let height: CGFloat = 45
        var statusBarHeight: CGFloat = 0
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self as? UINavigationBarDelegate
        
        let navItem = UINavigationItem()
        navItem.title = "Create new channel"
        let closeItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapCloseButtonNewChannel))
        navItem.leftBarButtonItem = closeItem
        
        navbar.items = [navItem]
        
        view.addSubview(navbar)
        
        self.view?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
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
    
    @objc private func tapCloseButtonNewChannel() {
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
