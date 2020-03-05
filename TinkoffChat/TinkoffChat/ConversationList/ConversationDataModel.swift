//
//  ConversationDataModel.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 27.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

class ConversationDataModel {
    var onlineConversations = [ConversationCellModel]()
    var offlineConversations = [ConversationCellModel]()
    
    init() {
        setupData()
    }
    
    func setupData() {
        // Random data for conversation cell
        let names = ["Kelly Ochoa", "Macey Blundell", "Lacey-Mai Kirkland", "Dustin Bennett", "Rosie Austin", "Akaash Ashton", "Huxley Legge", "Kaila Patton", "Kunal Richmond", "Arjan Mcphee", "Rebeca Tillman", "Aiza Beattie", "Jemma Gallagher", "Jae Findlay", "Ameen Finch", "Julie Jensen", "Kodi Colley", "Christie Goodwin", "Aishah Mccarthy", "Camille Hubbard"]
        let lastMessages = ["We've known each other for so long",
                            "Please forgive me",
                            "Never gonna tell a lie and hurt you",
                            "hmmm",
                            "oops, forgot to add the file",
                            "Who knows...",
                            "Ok",
                            "Useful text",
                            nil,
                            "Argh! About to give up :(",
                            "why is everything broken",
                            "it's friday",
                            "Still can't get this right...",
                            "making this thing actually usable",
                            nil,
                            "I must have been drunk.",
                            "I have no idea what I'm doing here.",
                            "omgsosorry",
                            "Yes, I was being sarcastic.",
                            "should work now."]
        func generateRandomDate(daysBack: Int)-> Date?{
            let day = arc4random_uniform(UInt32(daysBack))+1
            let hour = arc4random_uniform(23)
            let minute = arc4random_uniform(59)
            
            let today = Date(timeIntervalSinceNow: 0)
            let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
//            let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            var offsetComponents = DateComponents()
            offsetComponents.day = -1 * Int(day - 1)
            offsetComponents.hour = -1 * Int(hour)
            offsetComponents.minute = -1 * Int(minute)
            
            let randomDate = gregorian.date(byAdding: offsetComponents, to: today, wrappingComponents: true)
            return randomDate
        }
        var randomNumbersForGenerateDataForOnline = Array(0..<10)
        var randomNumbersForGenerateDataForOffline = Array(10..<20)
        randomNumbersForGenerateDataForOnline.shuffle()
        randomNumbersForGenerateDataForOffline.shuffle()
        var randomDates = [Date?]()
        
        for _ in 0..<20 {
            let randomDate = generateRandomDate(daysBack: 3)
            randomDates.append(randomDate)
        }
        
        for i in randomNumbersForGenerateDataForOnline {
            let conversationCellOnline = ConversationCellModel(name: names[i], message: lastMessages[i], date: randomDates[i], isOnline: true, hasUnreadMessages: Bool.random())
            onlineConversations.append(conversationCellOnline)
        }
        for i in randomNumbersForGenerateDataForOffline {
            let conversationCellOffline = ConversationCellModel(name: names[i], message: lastMessages[i], date: randomDates[i], isOnline: false, hasUnreadMessages: Bool.random())
           
            offlineConversations.append(conversationCellOffline)
        }
    }
}
