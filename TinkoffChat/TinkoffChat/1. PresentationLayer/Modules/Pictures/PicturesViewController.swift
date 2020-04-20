//
//  PicturesViewController.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 20.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//
import Foundation
import UIKit

class PicturesViewController: UIViewController {
    
    var model: IPicturesModel!
    weak var collectionPickerDelegate: IPicturesViewControllerDelegate?
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var spinner: UIActivityIndicatorView!
    
    private let cellSize = (UIScreen.main.bounds.width - 22)/3.0
    
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
        spinner.hidesWhenStopped = true
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
        collectionView.delegate = self
    }
    
    private func configureNavigationPane() {
        let leftItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(close))
        
        navigationItem.setLeftBarButton(leftItem, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension PicturesViewController: UICollectionViewDelegate {
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
                
                self.model.fetchPicture(urlString: url, size: self.cellSize) { image in
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
            self.model.fetchPicture(urlString: picture.previewUrl, size: self.cellSize) { image in
                guard let image = image else { return }
                
                DispatchQueue.main.async {
                    cell.setup(image: image, picture: picture)
                }
                
            }
        }
        cell.layoutIfNeeded()
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PicturesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

// MARK: - ICollectionPickerController
extension PicturesViewController: ICollectionPickerController {
    
    @objc func close() {
        dismiss(animated: true)
    }
    
}
