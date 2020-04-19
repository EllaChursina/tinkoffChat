//
//  SearchParser.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 17.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

struct Response: Codable {
    let hits: [Picture]
}

class SearchImagesParser: IParser {
    typealias Model = [Picture]
    
    func parse(data: Data) -> Model? {
        do {
            return try JSONDecoder().decode(Response.self, from: data).hits
        } catch {
            print("Error trying to convert data to JSON SearchParser")
            return nil
        }
    }
}
