//
//  ConversationsListTableViewCell.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell, ConfigurableView {
    
    struct ConversationCellModel {
        let name: String
        let message: String?
        let date: Date?
        let isOnline: Bool
        let hasUnreadMessages: Bool
        let picture: String?
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            dateLabel.isHidden = true
        }
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var pictureCellView: UIView!
    @IBOutlet weak var initialsCellImageLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        pictureCellView.layer.cornerRadius = pictureCellView.bounds.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        messageLabel?.font = .systemFont(ofSize: 13)
        profileImageView?.image = nil
        initialsCellImageLabel?.isHidden = true
        dateLabel?.isHidden = true
    }
    
    func configure(with model: ConversationCellModel) {
        selectionStyle = .none
        nameLabel.text = model.name
        messageLabel.font.withSize(13)
        
        if let picName = model.picture {
            profileImageView.image = UIImage(named: picName)
        }
        else {
            let initials = model.name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first ?? " ")") + "\($1.first ?? " ")" }
            initialsCellImageLabel.text = initials
            initialsCellImageLabel.isHidden = false
        }
        
        if model.isOnline {
            backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        }
        
        if let lastMessage = model.message {
            messageLabel.text = lastMessage
        }
        else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "Arial-ItalicMT", size: 13)
        }
        
        if model.hasUnreadMessages {
            messageLabel.font = .boldSystemFont(ofSize: 13)
        }
        
        let dateFormatter = DateFormatter()
        if let date = model.date {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
            }
            else {
                dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
            }
            dateLabel.text = dateFormatter.string(from: date)
            dateLabel.isHidden = false
        }
    }
}
