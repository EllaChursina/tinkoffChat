//
//  FirebaseChatService.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 24.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseChatService: ConversationDataProviderProtocol {

    static let shared = FirebaseChatService(channelReference: db.collection("channels"))
    
    static var db = Firestore.firestore()
    var channelReference: CollectionReference
    
    init(channelReference: CollectionReference) {
        self.channelReference = channelReference
    }

    func syncConversationsData(reference: CollectionReference, viewController: UIViewController?, tableView: UITableView?){
        
        guard let vc = viewController as? ConversationListViewController else {return}
        
        reference.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
            print("Error fetching document: \(error!)")
            return
            }
            
            let channels = snapshot.documents
            vc.dataDictionary.removeAll()
            
            for channel in channels {
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
                    
                    if var channelValue = vc.dataDictionary[channelKey] {
                        channelValue.append(newChannel)
                        vc.dataDictionary[channelKey] = channelValue
                    } else {
                        vc.dataDictionary[channelKey] = [newChannel]
                    }
                    
                } else {continue}
                if let activeChannelArray = vc.dataDictionary["Active"]{
                    vc.dataDictionary["Active"] = activeChannelArray.sorted(by: {$0.lastActivity > $1.lastActivity})
                }
                
                if let notActiveChannelArray = vc.dataDictionary["Not Active"]{
                    vc.dataDictionary["Not Active"] = notActiveChannelArray.sorted(by: {$0.lastActivity > $1.lastActivity})
                }
            }
            DispatchQueue.main.async {
                tableView?.reloadData()
            }
        }
    }
    
    func addNewConversationsDocument(reference: CollectionReference, viewController: UIViewController?) {
        guard let vc = viewController as? NewChannelViewController else {return}
        guard let content = vc.newChannelTextField.text else {errorAddingChannel(viewController: vc);
        return}
        let newChannel = Channel(identifier: String(Int.random(in: 1...1000)), name: content, lastMessage: "El create new channel", lastActivity: Date())
        reference.addDocument(data: newChannel.toDict)
        vc.newChannelTextField.text = ""
        newChannelAddedSuccessfully(viewController: vc)
    }
    
    func newChannelAddedSuccessfully(viewController: UIViewController?) {
        let alertController = UIAlertController(title: "The new channel added to TinkoffChat successfully", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        viewController?.present(alertController, animated: true)
        
    }
    
    func errorAddingChannel(viewController: UIViewController?) {
        let alertController = UIAlertController(title: "Error", message: "Error adding the new channel", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        viewController?.present(alertController, animated: true)
    }
}

