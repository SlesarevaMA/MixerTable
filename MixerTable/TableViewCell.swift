//
//  TableViewCell.swift
//  MixerTable
//
//  Created by Margarita Slesareva on 12.02.2024.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configure(with model: CellViewModel) {
        var content = defaultContentConfiguration()
        content.text = model.title
        contentConfiguration = content
        
        accessoryType = model.isCheckmarked ? .checkmark : .none
    }
}
