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
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")

    @IBOutlet weak var newChannelButton: UIButton!
    @IBOutlet weak var newChannelTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newChannelButton.layer.cornerRadius = 10
        newChannelButton.layer.borderWidth = 1
        newChannelButton.layer.borderColor = UIColor.black.cgColor
        
        
        

        // Do any additional setup after loading the view.
    }
    
   
    
    @IBAction func createNewChannelButton(_ sender: UIButton) {
        print("try create channel")
        guard let content = newChannelTextField.text else {print("No new channels")
            return}
        let newChannel = Channel(identifier: String(Int.random(in: 1...1000)), name: content, lastMessage: "El create new channel", lastActivity: Date())
        reference.addDocument(data: newChannel.toDict)
    }
    
    // MARK: -Navigation
    
    @IBAction private func tapCloseButtonNewChannel (_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
