//
//  FirebaseService.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 22.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService {
    static var db = Firestore.firestore()
    var reference: CollectionReference
    
    init(reference: CollectionReference) {
        self.reference = reference
    }
}

extension FirebaseService: FirebaseProtocol {
    func addListener(reference: CollectionReference) {
        
    }
}
