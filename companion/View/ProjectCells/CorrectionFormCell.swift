//
//  CorrectionFormCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/17/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class CorrectionFormCell: UITableViewCell {

    @IBOutlet private weak var bgView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 3
    }
    
    func fillQACell(title: String, question: String) {
        titleLabel.text = title
        questionLabel.text = question
    }

}
