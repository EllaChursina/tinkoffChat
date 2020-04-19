//
//  PictureCell.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 17.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell, IPictureCellConfiguration {
    
    var previewUrl, largeImageUrl: String?
    
    @IBOutlet var imageView: UIImageView!
    
    func setup(image: UIImage, picture: Picture) {
        imageView.image = image
        previewUrl = picture.previewUrl
        largeImageUrl = picture.largeImageUrl
    }
    
}
