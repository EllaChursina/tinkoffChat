//
//  Logger.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 16.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

enum LogTag: String {
    case AppDelegate
    case ViewController
}

struct Logger {
    // Switch var "loggerOn" on "false" state if you want turn off logging
    static var loggerOn = true
    static func log(tag: LogTag, message: String) {
        guard loggerOn == true else {return}
        print("tag: \(tag), message: \(message)")
    }
}



