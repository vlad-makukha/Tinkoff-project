//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: String(describing: ConversationsListTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)
    
    // MARK: - UIViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.current.backgroundColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        let themesVC = ThemesViewController()
        themesVC.title = "Settings"
        
        themesVC.themeApplied = { [weak self] in
            self?.tableView.backgroundColor = Theme.current.backgroundColor
            self?.view.backgroundColor = Theme.current.backgroundColor
            self?.navigationController?.navigationBar.barStyle = Theme.current.barStyle
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.current.textColor]
            self?.navigationController?.navigationBar.isTranslucent = false
        }
        
        navigationController?.pushViewController(themesVC, animated: true)
    }

}

// MARK: -  UITableViewDataSource, UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = Theme.current.textBackgroundColor
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationsListTableViewCell else { return UITableViewCell() }
        let chat = chats[indexPath.section][indexPath.row]
        cell.configure(with: chat)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationVC =  ConversationViewController()
        conversationVC.title = chats[indexPath.section][indexPath.row].name
        navigationController?.pushViewController(conversationVC, animated: true)
    }
}
