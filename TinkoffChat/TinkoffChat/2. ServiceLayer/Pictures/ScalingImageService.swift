//
//  ScalingImageService.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 20.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

class ScalingImageService: IScalingImageService {
    func scaleImage(image: UIImage, size: CGFloat) -> UIImage {
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), true, scale)
        image.draw(in: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = scaledImage else {
            return UIImage()
        }
        return image
    }
}
