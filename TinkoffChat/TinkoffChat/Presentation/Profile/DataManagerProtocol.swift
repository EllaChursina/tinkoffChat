//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 13.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
    func saveProfile(profile: Profile, completion: @escaping (_ success: Bool) -> ())
    func loadProfile(completion: @escaping (_ profile: Profile?) -> ())
}
