//
//  PictureCell.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 20.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

import UIKit

class PictureCell: UICollectionViewCell, IPictureCellConfiguration {
    
    var previewUrl, largeImageUrl: String?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
    }
    
    func setup(image: UIImage, picture: Picture) {
        imageView.image = image
        previewUrl = picture.previewUrl
        largeImageUrl = picture.largeImageUrl
        activityIndicator.stopAnimating()
    }
    
}
