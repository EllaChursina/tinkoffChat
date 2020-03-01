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
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var setProfileImageButton: UIButton!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var usersDescriptionLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
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
    
//    required init?(coder : NSCoder) {
//        super.init(coder: coder)
//        //print(editButton.frame)
//        //Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value
//        //We can't get the frame of the button, because ProfileView is in initialization process
//        //and has not placed. So the frame also does not exist and return nil.
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(#function) called. EditButton frame is \(editButton.frame) at the moment")
        
        profileImageView.layer.cornerRadius = 40
        setProfileImageButton.layer.cornerRadius = 40
        
        editButton.layer.cornerRadius = 10
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(#function) called. EditButton frame is \(editButton.frame) at the moment")
        // If we have different screen sizes in the storyboard and simulator,
        //then the values of the button borders will be different.
        //In viewDidLoad method, the frame will be the original as in the storyboard.
        //When viewDidAppear is called, AutoLayout will calculate the frame according
        //to the size of the simulator screen before the view presented on the screen.
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
