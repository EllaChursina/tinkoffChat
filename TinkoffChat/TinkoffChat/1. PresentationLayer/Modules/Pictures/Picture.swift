//
//  Picture.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 17.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

struct Picture: Codable {
    let previewUrl: String
    let largeImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case previewUrl = "previewURL"
        case largeImageUrl = "largeImageURL"
    }
}
