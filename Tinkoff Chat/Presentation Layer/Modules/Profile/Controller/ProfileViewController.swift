//
//  ProfileViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 21.09.2021.
//

import UIKit
import Photos

class ProfileViewController: UIViewController, UINavigationControllerDelegate,
                             UIImagePickerControllerDelegate, UITextViewDelegate {

    // MARK: - Properties

    private lazy var imagePicker = UIImagePickerController()
    private var isProfileEditing = false
    private var isProfileNameChanged = false
    private var isProfileDescriptionChanged = false
    private var bottom: CGFloat = 0.0

    @IBOutlet weak var profilePictureImageView: UIImageView! {
        didSet {
            profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2
            profilePictureImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var editInfoButton: UIButton!
    @IBOutlet weak var gcdSaveButton: UIButton!
    @IBOutlet weak var operationSaveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    // MARK: - UIViewController lifecycle methods

    // Срабатывает после загрузки View
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        gcdSaveButton.isHidden = true
        operationSaveButton.isHidden = true
        loadTextData()
        loadPictureData()
        addNotificationKeyboardObserver()
    }

    // Срабатывает после того, как размер View изменился под размер экрана
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureItems()
    }

    // Срабатывает, когда View появляется на экране
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(editButton.frame)
        bottom = self.view.frame.origin.y
    }

    // MARK: - Methods

    private func configureItems() {
        view.backgroundColor = Theme.current.backgroundColor
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.bounds.width / 2
        configureButton(button: editInfoButton)
        configureButton(button: gcdSaveButton)
        configureButton(button: operationSaveButton)
    }

    private func configureButton(button: UIButton) {
        button.backgroundColor = Theme.current.textBackgroundColor
        button.layer.cornerRadius = button.bounds.height / 2
    }

    // MARK: User interaction

//    @IBAction func closeButtonTapped(_ sender: UIButton) {
//        presentingViewController?.dismiss(animated: true, completion: nil)
//    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
           dismiss(animated: true)
       }
    @IBAction func editInfoButtonTapped(_ sender: UIButton) {
        changeItemsConfigure()
        if !isProfileEditing {
            loadTextData()
            stopButtonAnimation()
        } else { startButtonAnimation(button: sender) }
    }
    @IBAction func gcdSaveButtonTapped(_ sender: UIButton) {
        changeItemsConfigure()
        saveDataToFile(isWithGCD: true)
    }
    @IBAction func operationSaveButtonTapped(_ sender: UIButton) {
        changeItemsConfigure()
        saveDataToFile(isWithGCD: false)
    }

    @IBAction func nameTextFieldChanged(_ sender: UITextField) {
        isProfileNameChanged = true
        gcdSaveButton.isEnabled = true
        operationSaveButton.isEnabled = true
    }

    func textViewDidChange(_ textView: UITextView) {
        isProfileDescriptionChanged = true
        gcdSaveButton.isEnabled = true
        operationSaveButton.isEnabled = true
    }
    
    private func changeItemsConfigure() {
        gcdSaveButton.isEnabled = false
        operationSaveButton.isEnabled = false
        isProfileEditing = !isProfileEditing
        isProfileEditing ? editInfoButton.setTitle("Отмена", for: .normal) : editInfoButton.setTitle("Редактировать", for: .normal)
        gcdSaveButton.isHidden = !gcdSaveButton.isHidden
        operationSaveButton.isHidden = !operationSaveButton.isHidden
        nameTextField.isEnabled = !nameTextField.isEnabled
        descriptionTextView.isEditable = !descriptionTextView.isEditable
    }
    
    // MARK: Button animation
    
    private func startButtonAnimation(button: UIButton) {
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotation.values = [0, NSNumber(value: Double.pi / 10), 0, NSNumber(value: -Double.pi / 10), 0]
        rotation.isCumulative = true
        
        let translationX = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translationX.values = [0, -5, 0, 5]
        translationX.isAdditive = true
        
        let translationY = CAKeyframeAnimation(keyPath: "transform.translation.y")
        translationY.values = [0, -5, 0, 5]
        translationY.isAdditive = true
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.autoreverses = true
        group.animations = [rotation, translationX, translationY]
        group.fillMode = .removed
        button.layer.add(group, forKey: "shakeIt")
    }
    
    private func stopButtonAnimation() {
        self.editInfoButton.layer.removeAnimation(forKey: "shakeIt")
    }
    
    // MARK: - Work with datamanagers

    private func saveDataToFile(isWithGCD: Bool) {
        guard let name = nameTextField.text, let description = descriptionTextView.text, nameTextField.text != "", descriptionTextView.text != ""
            else { presentAlertWithTitle(title: "Ошибка", message: "Имя и описание профиля должны быть заполнены", options: "ОК") { (_) in
            }
                changeItemsConfigure()
                return }
        if isWithGCD {
            GCDDataManager.saveTextDataToFiles(name: name,
                                               description: description,
                                               isNameChanged: isProfileNameChanged,
                                               isDescriptionChanged: isProfileDescriptionChanged)
        } else {
            OperationDataManager.saveTextDataToFiles(name: name,
                                                     description: description,
                                                     isNameChanged: isProfileNameChanged,
                                                     isDescriptionChanged: isProfileDescriptionChanged)
        }
        stopButtonAnimation()
    }
    
    private func loadTextData() {
        let data = GCDDataManager.loadTextDataFromFiles()
        //        let data = OperationDataManager.loadTextDataFromFiles()
        self.nameTextField.text = data.name
        self.descriptionTextView.text = data.description ?? "Description of your profile"
    }
    
    private func loadPictureData() {
        if let picture = GCDDataManager.loadPictureFromFile() {
            //        if let picture = OperationDataManager.loadPictureFromFile() {
            self.profilePictureImageView.image = picture
            self.initialsLabel.isHidden = true
        }
    }

    // MARK: - Work with avatar

    @IBAction func editPictureTapped(_ sender: UIButton) {
        presentAlertWithTitle(title: "Изменить изображение", message: nil, options: "Установить из галереи", "Сделать фото", "Загрузить", "Отмена") { (option) in
            switch option {
            case "Установить из галереи":
                self.choosePicture()
            case "Сделать фото":
                self.takePicture()
            case "Загрузить":
                let picVC = PicturesViewController()
                picVC.pictureSelected = { [weak self] image in
                    self?.profilePictureImageView.image = image
                    self?.initialsLabel.isHidden = true
                    GCDDataManager.savePictureToFile(picture: image)
                }
                self.present(UINavigationController(rootViewController: picVC), animated: true)
            default:
                break
            }
        }
    }

    private func takePicture() {
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
        if isCameraAvailable {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            presentAlertWithTitle(title: "Ошибка", message: "К сожалению, камера недоступна", options: "ОК") { (_) in
            }
        }
    }
    
    private func choosePicture() {
        let isPhotoLibraryAvailable = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        if isPhotoLibraryAvailable {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            presentAlertWithTitle(title: "Ошибка", message: "К сожалению, галерея недоступна", options: "ОК") { (_) in
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            profilePictureImageView.image = image
            initialsLabel.isHidden = true
            GCDDataManager.savePictureToFile(picture: image)
            //            OperationDataManager.savePictureToFile(picture: image)
        }
    }
    
    //    let initials = model.name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first ?? " ")") + "\($1.first ?? " ")" }

    // MARK: - Work with keyboard

    private func addNotificationKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == bottom {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == bottom - keyboardFrame.height {
            self.view.frame.origin.y += keyboardFrame.height
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
