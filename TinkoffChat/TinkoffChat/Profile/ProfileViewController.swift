//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 21.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: -UI
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var setProfileImageButton: UIButton!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var usersDescriptionLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var closeProfileButton: UIBarButtonItem!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: -Edit mode UI
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var usersDescriptionTextField: UITextField!
    @IBOutlet private weak var gcdButton: UIButton!
    @IBOutlet private weak var operationButton: UIButton!
    
    // MARK: -Models
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
    
    private var profile: Profile?
    private var dataManager: DataManagerProtocol? = GCDDataManager()
    
    // MARK: -Editing Dependencies
    var editMode = false {
        didSet {
            self.setEditingState(editing: editMode)
        }
    }
    
    private var saveChanges: ( () -> Void )?
    
    private var dataWasChanged: Bool {
        get {
            return profile?.usernameChanged ?? false || profile?.usersDescriptionChanged ?? false || profile?.imageChanged ?? false
        }
    }
    
    // MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(#function) called. EditButton frame is \(editButton.frame) at the moment")
        
        
        profileImageView.layer.cornerRadius = 40
        setProfileImageButton.layer.cornerRadius = 40
        
        editButton.layer.cornerRadius = 10
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
        
        gcdButton.layer.cornerRadius = 10
        operationButton.layer.cornerRadius = 10
        
        activityIndicator.hidesWhenStopped = true
        
        editMode = false
        loadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillSnow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: -Navigation
    
    @IBAction private func tapCloseButtonProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -Action
    
    @IBAction private func actionSetProfileImageButton(_ sender: Any) {
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
    
    @IBAction private func editProfileButton(_ sender: Any) {
        editMode = true
        enabledSaveButtonsState(enabled: false)
    }
    
    
    @IBAction func saveButtonsTapped(_ sender: UIButton) {
        usernameTextField.resignFirstResponder()
        usersDescriptionTextField.resignFirstResponder()
        
        saveChanges = {
            self.activityIndicator.startAnimating()
            self.enabledSaveButtonsState(enabled: false)
            
            if let usernameChanged = self.profile?.usernameChanged, usernameChanged == true {
                self.profile?.username = self.usernameTextField.text
            }
            if let usersDescriptionChanged = self.profile?.usersDescriptionChanged, usersDescriptionChanged == true {
                self.profile?.usersDescription = self.usersDescriptionTextField.text
            }
            if let imageChanged = self.profile?.imageChanged, imageChanged == true {
                self.profile?.avatar = self.profileImageView.image
            }
            
            let buttonTitle = sender.titleLabel?.text
            
            if buttonTitle == "GCD" {
                self.dataManager = GCDDataManager()
            } else {
                self.dataManager = OperationDataManager()
            }
            
            guard let userProfile = self.profile else {return}
            self.dataManager?.saveProfile(profile: userProfile, completion: { (saveSucceeded : Bool) in
                self.activityIndicator.stopAnimating()
                if saveSucceeded {
                    self.successfulSaveAlert()
                    self.loadData()
                } else {
                    self.errorSaveAlert()
                }
                
                self.enabledSaveButtonsState(enabled: true)
                self.editMode = !saveSucceeded
            })
        }
        self.saveChanges?()
    }
    
    @IBAction func usernameChangedAfterEditing(_ sender: UITextField) {
        if let newName = sender.text {
            self.profile?.usernameChanged = (newName != (self.profile?.username ?? ""))
            self.enabledSaveButtonsState(enabled: self.dataWasChanged)
        }
    }
    
    @IBAction func usersDescriptionChangedByEditing(_ sender: UITextField) {
        if let newUsersDescription = sender.text {
            self.profile?.usersDescriptionChanged = (newUsersDescription != (self.profile?.usersDescription ?? ""))
            self.enabledSaveButtonsState(enabled: self.dataWasChanged)
            
        }
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
    
    //MARK: - Editing
    
    private func loadData() {
        dataManager?.loadProfile(completion: { (profile) in
            if let userProfile = profile {
                self.profile = userProfile
            }
            
            self.profileImageView.image = profile?.avatar ?? UIImage.init(named: "placeholder-user")
            self.profileImageView.contentMode = .scaleAspectFill
            self.usernameLabel.text = profile?.username ?? "Enter your name"
            self.usersDescriptionLabel.text = profile?.usersDescription ?? "Enter your bio"
            self.usernameTextField.text = self.usernameLabel.text
            self.usersDescriptionTextField.text = self.usersDescriptionLabel.text
            
            self.profile = Profile(username: self.usernameLabel.text, usersDescription: self.usersDescriptionLabel.text, avatar: self.profileImageView.image)
        })
    }
    
    private func setEditingState(editing: Bool) {
        if(editing) {
            usernameLabel.text = "Enter your name"
            usersDescriptionLabel.text = "Enter your bio"
        }
        
        editButton.isHidden = editing
        gcdButton.isHidden = !editing
        operationButton.isHidden = !editing
        setProfileImageButton.isHidden = !editing
        
        usernameTextField.isHidden = editing
        usernameTextField.isHidden = !editing
        
        usersDescriptionLabel.isHidden = editing
        usersDescriptionTextField.isHidden = !editing
    }
    
    private func enabledSaveButtonsState(enabled: Bool) {
        gcdButton.isEnabled = enabled
        operationButton.isEnabled = enabled
    }
    
    private func successfulSaveAlert() {
        let alertController = UIAlertController(title: "Changes saved successfully", message: nil, preferredStyle: .alert)
        let okSaveButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okSaveButton)
        present(alertController, animated: true)
    }
    
    private func errorSaveAlert() {
        let alertController = UIAlertController(title: "Save Error", message: nil, preferredStyle: .alert)
        let okErrorButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let retrySaveButton = UIAlertAction(title: "Retry", style: .default) { action in
            self.saveChanges?()
        }
        alertController.addAction(okErrorButton)
        alertController.addAction(retrySaveButton)
        present(alertController, animated: true)
    }
    
    //MARK: - Keyboard
    
    @objc private func keyboardWillSnow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
             let keyboardHeight = keyboardFrame.cgRectValue.height
             self.view.frame.origin.y = -keyboardHeight + 16
             print("keyboard height is:" , keyboardHeight)
           }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: -UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return self.imagePickerControllerDidCancel(picker)
        }
        guard let fixedOrientationImage = image.fixedOrientation() else {return}
        self.selectedImage = fixedOrientationImage
        
        if let savedImage = self.profile?.avatar {
            guard let newImage = fixedOrientationImage.pngData(),
                  let oldImage = savedImage.pngData() else {return}
            profile?.imageChanged = !newImage.elementsEqual(oldImage)
        } else {
            profile?.imageChanged = true
        }
        enabledSaveButtonsState(enabled: self.dataWasChanged)
        
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
