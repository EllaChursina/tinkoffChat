//
//  PicturesModel.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 17.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

class PicturesModel: IPicturesModel {
    private let picturesService: IPicturesService
    private let scaleImageService: IScalingImageService
    var data: [Picture] = []
    
    init(picturesService: IPicturesService, scaleImageService: IScalingImageService) {
        self.picturesService = picturesService
        self.scaleImageService = scaleImageService
    }
    
    func fetchPicture(urlString: String, size: CGFloat, completionHandler: @escaping (UIImage?) -> ()) {
        picturesService.downloadPicture(urlString: urlString) { image, error in
            
            guard let image = image else {
                return completionHandler(nil)
            }
            
            let scalingImage = self.scaleImageService.scaleImage(image: image, size: size)
            
            completionHandler(scalingImage)
        }
    }
    
    func fetchAllPictures(completionHandler: @escaping ([Picture]?, String?) -> ()) {
        picturesService.getPictures { pictures, errorText in
            
            guard let pictures = pictures else {
                completionHandler(nil, errorText)
                return
            }
            
            completionHandler(pictures, nil)
        }
    }
    
    
}
