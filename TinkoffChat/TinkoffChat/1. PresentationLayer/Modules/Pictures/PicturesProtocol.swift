//
//  PicturesProtocol.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 17.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

protocol ICollectionPickerController: class {
    func close()
}

protocol IPicturesViewControllerDelegate: class {
    func collectionPickerController(_ picker: ICollectionPickerController, didFinishPickingImage image: UIImage)
}

protocol IPictureCellConfiguration {
    var previewUrl: String? { get set }
    var largeImageUrl: String? { get set }
}

protocol IPicturesModel: class {
    var data: [Picture] { get set }
    
    func fetchAllPictures(completionHandler: @escaping ([Picture]?, String?) -> ())
    func fetchPicture(urlString: String, size: CGFloat, completionHandler: @escaping (UIImage?) -> ())
}
