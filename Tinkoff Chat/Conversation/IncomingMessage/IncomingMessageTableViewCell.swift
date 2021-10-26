//
//  IncomingMessageTableViewCell.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import UIKit

class IncomingMessageTableViewCell: UITableViewCell, ConfigurableView {
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var incomingTextLabel: UILabel!
    @IBOutlet weak var incomingBubbleView: UIView!{
        didSet{
            incomingBubbleView.layer.cornerRadius = 10
            incomingBubbleView.layer.masksToBounds = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = Theme.current.backgroundColor
        incomingBubbleView.backgroundColor = Theme.current.incomingMessageCellBackgroundColor
    }
    
    func configure(with model: Message) {
        selectionStyle = .none
        incomingTextLabel.text = model.content
        nameLabel.text = model.senderName
        
        let dateFormatter = DateFormatter()
        let date = model.created
        if Calendar.current.isDateInToday(date) {
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
        }
        dateLabel.text = dateFormatter.string(from: date)
    }
}
