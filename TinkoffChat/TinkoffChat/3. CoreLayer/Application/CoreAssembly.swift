//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 12.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataManager: ICoreDataManager { get }
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    
    lazy var coreDataManager: ICoreDataManager = CoreDataManager()
    lazy var requestSender: IRequestSender = RequestSender()
}
