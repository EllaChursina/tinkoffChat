//
//  PicturesViewController.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 17.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

class PicturesViewController: UIViewController {
    let model: IPicturesModel!
    weak var collectionPickerDelegate: IPicturesViewControllerDelegate?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    private let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureCollectionView()
        configureNavigationPane()
    }
    
    private func configureData() {
        spinner.layer.cornerRadius = spinner.frame.size.width / 2
        spinner.startAnimating()
        
        model.fetchAllPictures() { [weak self] pictures, error in
            
            if let pictures = pictures {
                self?.model.data = pictures
                
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    self?.collectionView.reloadData()
                }
                
            } else {
                self?.spinner.stopAnimating()
                self?.showErrorMessage(error)
            }
        }
    }
    
    private func showErrorMessage(_ message: String?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error occured", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
            
            self.present(alertController, animated: true)
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "PictureCell", bundle: nil), forCellWithReuseIdentifier: "PictureCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self as UICollectionViewDelegate
    }
    
    private func configureNavigationPane() {
        let leftItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(close))
        
        navigationItem.setLeftBarButton(leftItem, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension PicturesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PictureCell
        
        let identifier = "PictureCell"
        
        if let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PictureCell {
            cell = dequeuedCell
        } else {
            cell = PictureCell(frame: CGRect.zero)
        }
        
        let picture = model.data[indexPath.item]
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.model.fetchPicture(urlString: picture.previewUrl) { image in
                guard let image = image else { return }
                
                DispatchQueue.main.async {
                    cell.setup(image: image, picture: picture)
                }
                
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PictureCell {
            
            DispatchQueue.global(qos: .userInteractive).async {
                guard let url = cell.largeImageUrl else {
                    self.showErrorMessage("Error loading image")
                    return
                }
                
                DispatchQueue.main.async {
                    self.collectionView.alpha = 0.1
                    self.spinner.startAnimating()
                }
                
                self.model.fetchPicture(urlString: url) { image in
                    DispatchQueue.main.async {
                        self.collectionView.alpha = 1
                        self.spinner.stopAnimating()
                        
                        guard let image = image else {
                            self.showErrorMessage("Error fetching image")
                            return
                        }
                        self.collectionPickerDelegate?.collectionPickerController(self, didFinishPickingImage: image)
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PicturesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect = UIScreen.main.bounds
        let anotherOne = itemsPerRow + 1
        
        let width = screenRect.size.width - 10.0 * anotherOne
        let height = width / itemsPerRow
        
        return CGSize(width: floor(height), height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

// MARK: - ICollectionPickerController
extension PicturesViewController: ICollectionPickerController {
    
    @objc func close() {
        dismiss(animated: true)
    }
    
}
