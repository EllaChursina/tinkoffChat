//
//  PicturesService.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 17.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

class PicturesService: IPicturesService {
    private let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func downloadPicture(urlString: String, completionHandler: @escaping (UIImage?, String?) -> ()) {
        
        let requestConfig = RequestsFactory.PixabayRequests.downloadImage(urlString: urlString)
        
        requestSender.send(config: requestConfig) { (result: Result<UIImage>) in
            
            switch result {
            case .success(let picture):
                completionHandler(picture, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func getPictures(completionHandler: @escaping ([Picture]?, String?) -> Void) {
        
        let requestConfig = RequestsFactory.PixabayRequests.searchImages()
        
        requestSender.send(config: requestConfig) { (result: Result<[Picture]>) in
            
            switch result {
            case .success(let pictures):
                completionHandler(pictures, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
}
