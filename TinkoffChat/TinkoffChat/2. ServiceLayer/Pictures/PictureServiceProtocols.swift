//
//  PictureServiceProtocols.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 17.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

protocol IPicturesService {
    
    func getPictures(completionHandler: @escaping ([Picture]?, String?) -> ())
    
    func downloadPicture(urlString: String, completionHandler: @escaping (UIImage?, String?) -> ())
    
}

protocol IScalingImageService {
    func scaleImage(image: UIImage, size: CGFloat) -> UIImage
}
