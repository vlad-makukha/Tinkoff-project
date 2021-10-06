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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}

// MARK: -  UITableViewDataSource, UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource{
    
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
}
