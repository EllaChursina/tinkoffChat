//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 12.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

protocol IAppUser {
  var username: String? { get set }
  var usersDescription: String? { get set }
  var avatar: UIImage? { get set }
}



protocol IAppUserModel: IAppUser {
  func set(on profile: IAppUser)
  func save(_ completion: @escaping (Bool) -> ())
  func load(_ completion: @escaping (IAppUser?) -> ())
}



class Profile: IAppUser {

  var username: String?
  var usersDescription: String?
  var avatar: UIImage?

  init(username: String? = nil, usersDescription: String? = nil, avatar: UIImage? = nil) {
    self.username = username
    self.usersDescription = usersDescription
    self.avatar = avatar
  }

}

class ProfileModel: IAppUserModel {
  private let dataService: ICoreDataManager

  var username: String?
  var usersDescription: String?
  var avatar: UIImage?


  init(dataService: ICoreDataManager, username: String? = nil, usersDescription: String? = nil, avatar: UIImage? = nil) {
    self.dataService = dataService

    self.username = username
    self.usersDescription = usersDescription
    self.avatar = avatar
  }


  func set(on profile: IAppUser) {
    self.username = profile.username
    self.usersDescription = profile.usersDescription
    self.avatar = profile.avatar
  }


  func save(_ completion: @escaping (Bool) -> ()) {
    dataService.saveAppUser(self, completion: completion)
  }


  func load(_ completion: @escaping (IAppUser?) -> ()) {
    dataService.loadAppUser(completion: completion)
  }

}
