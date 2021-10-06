//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import UIKit

class ConversationViewController: UIViewController {
    
    private let incomingCellIdentifier = String(describing: IncomingMessageTableViewCell.self)
    private let outgoingCellIdentifier = String(describing: OutgoingMessageTableViewCell.self)
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: String(describing: IncomingMessageTableViewCell.self), bundle: nil), forCellReuseIdentifier: incomingCellIdentifier)
            tableView.register(UINib(nibName: String(describing: OutgoingMessageTableViewCell.self), bundle: nil), forCellReuseIdentifier: outgoingCellIdentifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 44.0
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            tableView.sectionHeaderHeight = 0.0;
            tableView.sectionFooterHeight = 0.0;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messagesList[indexPath.section]
        if message.isMessageIncoming {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: incomingCellIdentifier, for: indexPath) as? IncomingMessageTableViewCell else { return UITableViewCell() }
            let incomingMessage = IncomingMessageTableViewCell.ConversationCellModel(text: message.text)
            
            cell.configure(with: incomingMessage)
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: outgoingCellIdentifier, for: indexPath) as? OutgoingMessageTableViewCell else { return UITableViewCell() }
            
            let outgoingMessage = OutgoingMessageTableViewCell.ConversationCellModel(text: message.text)
            
            cell.configure(with: outgoingMessage)
            return cell
        }
    }
    
}
