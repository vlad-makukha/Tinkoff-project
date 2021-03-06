//
//  ThemesViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 13.10.2021.
//

import UIKit

class ThemesViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var classicView: UIView!
    @IBOutlet weak var nightView: UIView!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var classicImageView: UIImageView!
    @IBOutlet weak var nightImageView: UIImageView!
    @IBOutlet weak var dayImageView: UIImageView!
    
    // MARK: - Delegate
    // weak var delegate: ThemePickerDelegate?
    
    // MARK: - Closure
    var themeApplied: (() -> Void)?
    
    // MARK: - UIViewController lifecycle methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    @IBAction func classicThemeButtonTapped(_ sender: UIButton) {
        Theme.classic.apply()
        setupView()
        // MARK: - Delegate
        // delegate?.ThemeApplied()
        // MARK: - Closure
        themeApplied?()
    }

    @IBAction func dayThemeButtonTapped(_ sender: UIButton) {
        Theme.day.apply()
        setupView()
        // MARK: - Delegate
        // delegate?.ThemeApplied()
        // MARK: - Closure
        themeApplied?()
    }
    @IBAction func nightThemeButtonTapped(_ sender: UIButton) {
        Theme.night.apply()
        setupView()
        // MARK: - Delegate
        // delegate?.ThemeApplied()
        // MARK: - Closure
        themeApplied?()
    }
    private func setupView() {
        view.backgroundColor = Theme.current.themesVCBackgroundColor
        nightImageView.layer.cornerRadius = classicView.bounds.height / 6
        nightImageView.clipsToBounds = true
        dayImageView.layer.cornerRadius = classicView.bounds.height / 6
        dayImageView.clipsToBounds = true
        classicImageView.layer.cornerRadius = classicView.bounds.height / 6
        classicImageView.clipsToBounds = true

        switch Theme.current {
        case .classic:
            classicImageView.layer.borderColor = UIColor.blue.cgColor
            classicImageView.layer.borderWidth = 2
            dayImageView.layer.borderWidth = 0
            nightImageView.layer.borderWidth = 0
        case .day:
            dayImageView.layer.borderColor = UIColor.blue.cgColor
            dayImageView.layer.borderWidth = 2
            classicImageView.layer.borderWidth = 0
            nightImageView.layer.borderWidth = 0
        case .night:
            nightImageView.layer.borderColor = UIColor.blue.cgColor
            nightImageView.layer.borderWidth = 2
            dayImageView.layer.borderWidth = 0
            classicImageView.layer.borderWidth = 0
        }
    }
}
// MARK: - Delegate
// protocol ThemePickerDelegate: AnyObject {
//    func ThemeApplied()
// }
