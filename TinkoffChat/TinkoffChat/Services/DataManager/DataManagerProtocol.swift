//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 13.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
    func saveProfile(_ profile: Profile, completion: @escaping (Error?) -> ())
    func loadProfile(completion: @escaping (Profile?, Error?) -> ())
}
