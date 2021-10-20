//
//  ProfileViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 21.09.2021.
//

import UIKit
import Photos

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    // MARK: - Properties
    
    let logFor = Logger()

    var imagePicker = UIImagePickerController()
    var isProfileEditing = false
    var isProfileNameChanged = false
    var isProfileDescriptionChanged = false
    var bottom: CGFloat = 0.0
    
    @IBOutlet weak var profilePictureImageView: UIImageView!{
        didSet{
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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - UIViewController lifecycle methods
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //print(editButton.frame)
        //Thread 1: Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value
        //Проблема возникла потому что frame=nil, так как view и объекты еще не загружены, следовательно frame не определено
    }
    
    // Срабатывает после загрузки View
    override func viewDidLoad() {
        super.viewDidLoad()
        print(editButton.frame)
        //Значение свойства frame указанного в Storyboard устройства
        logFor.log(message: "View moved from init to viewDidLoad")
        // Do any additional setup after loading the view.
//        view.backgroundColor = Theme.current.backgroundColor
        activityIndicator.hidesWhenStopped = true
        descriptionTextView.delegate = self
        gcdSaveButton.isHidden = true
        operationSaveButton.isHidden = true
        loadTextData()
        loadPictureData()
        addNotificationKeyboardObserver()
    }
    
    // Срабатывает перед появлением View на экране
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(editButton.frame)
        //Значение свойства frame для устройства на котором запускается Simulator + 20pt (status bar)
        logFor.log(message: "View moved from viewDidLoad to viewWillAppear")
    }
    
    // Срабатывает перед тем, как размер View поменяется под размер экрана
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logFor.log(message: "View moved from viewWillAppear to viewWillLayoutSubviews")
    }
    
    // Тут срабатывает AutoLayout
    
    // Срабатывает после того, как размер View изменился под размер экрана
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logFor.log(message: "View moved from viewWillLayoutSubviews to viewDidLayoutSubviews")
        configureItems()
    }
    
    // Срабатывает, когда View появляется на экране
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(editButton.frame)
        logFor.log(message: "View moved from viewDidLayoutSubviews to viewDidAppear")
        bottom = self.view.frame.origin.y
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        logFor.log(message: "View moved from viewDidAppear to viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        logFor.log(message: "View moved from viewWillAppear to deinit")
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
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editInfoButtonTapped(_ sender: UIButton) {
        changeItemsConfigure()
        if !isProfileEditing {
            loadTextData()
        }
    }
    
    @IBAction func gcdSaveButtonTapped(_ sender: UIButton) {
        changeItemsConfigure()
        saveDataToFileWithGCD()
    }
    
    @IBAction func operationSaveButtonTapped(_ sender: UIButton) {
        changeItemsConfigure()
        saveDataToFileWithOperation()
    }
    
    func changeItemsConfigure() {
        gcdSaveButton.isEnabled = false
        operationSaveButton.isEnabled = false
        isProfileEditing = !isProfileEditing
        isProfileEditing ? editInfoButton.setTitle("Отмена", for: .normal) : editInfoButton.setTitle("Редактировать", for: .normal)
        gcdSaveButton.isHidden = !gcdSaveButton.isHidden
        operationSaveButton.isHidden = !operationSaveButton.isHidden
        nameTextField.isEnabled = !nameTextField.isEnabled
        descriptionTextView.isEditable = !descriptionTextView.isEditable
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
    
    // MARK: Work with datamanagers
    
    func saveDataToFileWithGCD() {
        guard let name = nameTextField.text, let description = descriptionTextView.text, nameTextField.text != "", descriptionTextView.text != ""
        else { showErrorAlertController(with: "Имя и описание профиля должны быть заполнены")
            return }
        
        GCDDataManager.saveTextDataToFiles(profileVC: self, name: name, description: description, isProfileNameChanged: isProfileNameChanged, isProfileDescriptionChanged: isProfileDescriptionChanged)
    }
    
    func saveDataToFileWithOperation() {
        guard let name = nameTextField.text, let description = descriptionTextView.text, nameTextField.text != "", descriptionTextView.text != ""
        else { showErrorAlertController(with: "Имя и описание профиля должны быть заполнены")
            return }
        
        OperationDataManager.saveTextDataToFiles(profileVC: self, name: name, description: description, isProfileNameChanged: isProfileNameChanged, isProfileDescriptionChanged: isProfileDescriptionChanged)
    }
    
    func loadTextData() {
        let data = GCDDataManager.loadTextDataFromFiles()
        self.nameTextField.text = data.name
        self.descriptionTextView.text = data.description ?? "Description of your profile"
    }
    
    func loadPictureData() {
        if let picture = GCDDataManager.loadPictureFromFile() {
            self.profilePictureImageView.image = picture
            self.initialsLabel.isHidden = true
        }
    }
    
    // MARK: Work with avatar
    
    @IBAction func editPictureTapped(_ sender: UIButton) {
        let pictureChangingAlertController = UIAlertController(title: "Изменить изображение", message: nil, preferredStyle: .actionSheet)
        pictureChangingAlertController.addAction(UIAlertAction(title: "Установить из галлереи", style: .default, handler: { _ in self.choosePicture()}))
        pictureChangingAlertController.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in self.takePicture()}))
        pictureChangingAlertController.addAction(UIAlertAction.init(title: "Отменить", style: .cancel, handler: nil))
        present(pictureChangingAlertController, animated: true, completion: nil)
    }
    
    func choosePicture() {
        let isPhotoLibraryAvailable = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        if isPhotoLibraryAvailable {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            showErrorAlertController(with: "Галерея недоступна")
        }
    }
    
    func takePicture() {
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
        if isCameraAvailable {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            showErrorAlertController(with: "Камера недоступна")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            profilePictureImageView.image = image
            initialsLabel.isHidden = true
            OperationDataManager.savePictureToFile(picture: image)
        }
    }
    
    // MARK: Alert
    
    func showErrorAlertController(with message: String){
        let errorAlertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        errorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(errorAlertController, animated: true, completion: nil)
    }
    
    func showGCDDataSaveErrorAlertController(){
        let errorAlertController = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        
        let repitAction = UIAlertAction(title: "Повторить", style: .default) { action in
            self.saveDataToFileWithGCD()
        }
        errorAlertController.addAction(UIAlertAction(title: "OK", style: .default))
        errorAlertController.addAction(repitAction)
        present(errorAlertController, animated: true, completion: nil)
    }
    
    func showOperationDataSaveErrorAlertController(){
        let errorAlertController = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        
        let repitAction = UIAlertAction(title: "Повторить", style: .default) { action in
            self.saveDataToFileWithOperation()
        }
        errorAlertController.addAction(UIAlertAction(title: "OK", style: .default))
        errorAlertController.addAction(repitAction)
        present(errorAlertController, animated: true, completion: nil)
    }
    
    func showDataSaveAlertController(){
        let alertController = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Work with keyboard
    
    func addNotificationKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        //        self.view.frame.origin.y += keyboardFrame.height
        if self.view.frame.origin.y == bottom - keyboardFrame.height {
            self.view.frame.origin.y += keyboardFrame.height
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

