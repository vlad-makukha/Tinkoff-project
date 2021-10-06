//
//  ProfileViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 21.09.2021.
//

import UIKit
import Photos

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Properties
    
    let logFor = Logger()

    var imagePicker = UIImagePickerController()
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBOutlet weak var profilePictureImageView: UIImageView!{
        didSet{
            profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2
            profilePictureImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            saveButton.layer.cornerRadius = 18
            saveButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    
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
    }
    
    // Срабатывает, когда View появляется на экране
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(editButton.frame)
        logFor.log(message: "View moved from viewDidLayoutSubviews to viewDidAppear")
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
        }
    }
    
    func showErrorAlertController(with message: String){
        let errorAlertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        errorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(errorAlertController, animated: true, completion: nil)
    }
    
}

