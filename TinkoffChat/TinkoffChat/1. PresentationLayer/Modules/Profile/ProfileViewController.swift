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

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: -Edit mode UI
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var usersDescriptionTextField: UITextField!
    
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
    
    // MARK: -Dependencies
    var model: IAppUserModel!
    var presentationAssembly: IPresentationAssembly!
    // MARK: -Editing Dependencies
    
    private var dataWasChanged: Bool {
        get {
            return self.model.username != usernameTextField.text || self.model.usersDescription != usersDescriptionTextField.text || model.avatar != profileImageView.image
        }
    }
    
    // MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        addNavigationBar()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        usernameTextField.delegate = self
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        usersDescriptionTextField.delegate = self
        usersDescriptionTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        userIsInEditingMode = false
        
        model.load { [unowned self] profile in
            guard let profile = profile else {
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.model.set(on: profile)
            
            if let username = profile.username {
                self.usernameLabel.text = username
                self.usernameTextField.text = username
            }
            
            if let usersDescriprion = profile.usersDescription {
                self.usersDescriptionLabel.text = usersDescriprion
                self.usersDescriptionTextField.text = usersDescriprion
            }
            
            if let avatar = profile.avatar {
                self.selectedImage = avatar
            }
            
            self.activityIndicator.stopAnimating()
        }
            
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
        
        let downloadButton = UIAlertAction(title: "Download", style: .default) { (action: UIAlertAction) in
            let vc = self.presentationAssembly.picturesViewController()
            
            vc.collectionPickerDelegate = self
            
            let navigationController = UINavigationController()
            navigationController.viewControllers = [vc]
            
            self.present(navigationController, animated: true, completion: nil)
        }
        actionSheetPhotoController.addAction(downloadButton)
        
        self.present(actionSheetPhotoController, animated:  true)
    }
    
    @IBAction private func editProfileButton(_ sender: Any) {
        userIsInEditingMode = true
        handleSaveButtonStyle(canSave: false)
        
        editButton.isHidden = true
        saveButton.isHidden = false
        
        usernameTextField.isUserInteractionEnabled = true
        usernameTextField.layer.borderColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0).cgColor
        
        usersDescriptionTextField.isUserInteractionEnabled = true
        usersDescriptionTextField.layer.borderColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0).cgColor
    }
    
    
    @IBAction func saveButtonsTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        
        view.endEditing(true)
        
        handleSaveButtonStyle(canSave: false)
        
        if usernameTextField.text != model.username {
            model.username = usernameTextField.text
            usernameLabel.text = usernameTextField.text
        }
        
        if usersDescriptionTextField.text != model.usersDescription {
            model.usersDescription = usersDescriptionTextField.text
            usersDescriptionLabel.text = usersDescriptionTextField.text
        }
        
        if profileImageView.image != model.avatar {
            model.avatar = profileImageView.image
        }
        
        model.save() { [weak self] error in
            if !error {
                self?.successfulSaveAlert()
            } else {
                self?.errorSaveAlert()
            }
            
            self?.activityIndicator.stopAnimating()
            self?.saveButton.isHidden = true
            self?.editButton.isHidden = false
            
            self?.usernameTextField.layer.borderColor = UIColor.white.cgColor
            self?.usersDescriptionTextField.layer.borderColor = UIColor.white.cgColor
        }
        userIsInEditingMode = false
    }
    
    private func setupStyle() {
        
        profileImageView.layer.cornerRadius = 40
        setProfileImageButton.layer.cornerRadius = 40
        
        editButton.layer.cornerRadius = 10
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
        
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.black.cgColor
        
    }
    
    private func addNavigationBar(){
        let height: CGFloat = 45
        var statusBarHeight: CGFloat = 0
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self as? UINavigationBarDelegate
        
        let navItem = UINavigationItem()
        navItem.title = "Profile"
        let closeItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapCloseButton))
        navItem.leftBarButtonItem = closeItem
        
        navbar.items = [navItem]
        
        view.addSubview(navbar)
        
        self.view?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
    }
    
    @objc private func tapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    private var userIsInEditingMode = false {
        didSet {
            setEditingState(editing: userIsInEditingMode)
        }
    }
    
    private func setEditingState(editing: Bool) {
        
        editButton.isHidden = editing
        saveButton.isHidden = !editing
        setProfileImageButton.isHidden = !editing
        
        usernameTextField.isHidden = editing
        usernameTextField.isHidden = !editing
        
        usersDescriptionLabel.isHidden = editing
        usersDescriptionTextField.isHidden = !editing
    }
    
    func handleSaveButtonStyle(canSave: Bool) {
        if (canSave) {
            saveButton.alpha = 1
        } else {
            saveButton.alpha = 0.2
        }
        saveButton.isEnabled = canSave
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
            self.saveButtonsTapped(self)
        }
        alertController.addAction(okErrorButton)
        alertController.addAction(retrySaveButton)
        present(alertController, animated: true)
    }
    
    //MARK: - Keyboard
    
    @objc private func keyboardWillSnow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight + 82
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
        
        handleSaveButtonStyle(canSave: dataWasChanged)
        
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

// MARK: -UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(_ textField: UITextField) {
        handleSaveButtonStyle(canSave: dataWasChanged)
    }
}

// MARK: - IPicturesViewControllerDelegate
extension ProfileViewController: IPicturesViewControllerDelegate {
  func collectionPickerController(_ picker: ICollectionPickerController, didFinishPickingImage image: UIImage) {
    profileImageView.image = image
    handleSaveButtonStyle(canSave: true)
    picker.close()
  }

}
