//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 21.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //UI
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var setProfileImageButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usersDescriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    
    public var imagePickerController: UIImagePickerController?
    internal var selectedImage: UIImage? {
        get {
            return self.profileImageView.image
        }
        set {
            switch newValue {
            case nil:
                self.profileImageView.image = nil
            default:
                self.profileImageView.contentMode = .scaleAspectFill
                self.profileImageView.image = newValue
            }
        }
    }
    
    // MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 40
        setProfileImageButton.layer.cornerRadius = 40
        editButton.layer.cornerRadius = 10
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: -Action
    
    @IBAction func actionSetProfileImageButton(_ sender: Any) {
    print("Please choose a profile image")
        if self.imagePickerController != nil {
            self.imagePickerController?.delegate = nil
            self.imagePickerController = nil
        }
        
        self.imagePickerController = UIImagePickerController.init()
        
        let actionSheetPhotoController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel action sheet controller")
        }
        actionSheetPhotoController.addAction(cancelButton)
        let selectFromGalleryButton = UIAlertAction(title: "Select new from gallery", style: .default) { _ in
            print("Will select a new photo from gallery")
            self.openPhotoGallery()
        }
        actionSheetPhotoController.addAction(selectFromGalleryButton)
        let openCameraButton = UIAlertAction(title: "Take new photo", style: .default) { _ in
            print("Will take a new photo from camera")
            self.openCamera()
        }
        actionSheetPhotoController.addAction(openCameraButton)
        self.present(actionSheetPhotoController, animated:  true)
    }
    
    //MARK: - Photo
    
    func openPhotoGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            guard let controller = self.imagePickerController else {return}
            self.presentImagePicker(controller: controller, source: .photoLibrary)
        } else {
            showGalleryIsNotAvailableAlert()
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            guard let controller = self.imagePickerController else {return}
            self.presentImagePicker(controller: controller, source: .camera)
        } else {
            showCameraIsNotAvailableAlert()
        }
    }
    
    internal func presentImagePicker(controller: UIImagePickerController, source: UIImagePickerController.SourceType){
        controller.delegate = self
        controller.allowsEditing = false
        controller.sourceType = source
            if source == .camera {
                controller.cameraCaptureMode = .photo
                controller.modalPresentationStyle = .fullScreen
        }
        self.present(controller, animated: true)
    }
    
    func showCameraIsNotAvailableAlert() {
        let noCameraAlertController = UIAlertController(title: "No camera", message: "The camera is not available on this device", preferredStyle: .alert)
        let okCameraButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        noCameraAlertController.addAction(okCameraButton)
        present(noCameraAlertController, animated: true)
    }
    
    func showGalleryIsNotAvailableAlert() {
           let noGalleryAlertController = UIAlertController(title: "No camera", message: "The camera is not available on this device", preferredStyle: .alert)
           let okCameraButton = UIAlertAction(title: "OK", style: .default, handler: nil)
           noGalleryAlertController.addAction(okCameraButton)
           present(noGalleryAlertController, animated: true)
       }
    
}

// MARK: -UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return self.imagePickerControllerDidCancel(picker)
        }
        self.selectedImage = image
        picker.dismiss(animated: true) {
            picker.delegate = nil
            self.imagePickerController = nil
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            picker.delegate = nil
            self.imagePickerController = nil
        }
    }
}
