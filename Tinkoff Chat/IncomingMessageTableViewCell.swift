//
//  IncomingMessageTableViewCell.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import UIKit

class IncomingMessageTableViewCell: UITableViewCell, ConfigurableView {
    
    struct ConversationCellModel {
            let text: String
        }
    
    @IBOutlet weak var incomingTextLabel: UILabel!
    @IBOutlet weak var incomingBubbleView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
    }
    
    func configure(with model: ConversationCellModel) {
        incomingTextLabel.text = model.text
        selectionStyle = .none
    }
}
