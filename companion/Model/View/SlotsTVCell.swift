//
//  SlotsTVCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/18/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class SlotsTVCell: UITableViewCell {

    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillView(withSlot slot: Slot) {
        
        startLabel.text = getCorrectTime(fromString: slot.beginAt)
        endLabel.text = getCorrectTime(fromString: slot.endAt)
        
        if slot.scaleTeam != nil {
            startLabel.textColor =  #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            endLabel.textColor =    #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func getCorrectTime(fromString time: String?) -> String {
        
        let getDateFormatter = DateFormatter()
        getDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let printDateFormatter = DateFormatter()
        printDateFormatter.dateFormat = "HH:mm"
        
        let timeOffset = Double(TimeZone.current.secondsFromGMT())
        
        let correctString = String(time?.split(separator: ".").first ?? "")
        if let dateInSeconds = getDateFormatter.date(from: correctString)?.timeIntervalSince1970 {
            
            let startDate = Date(timeIntervalSince1970: dateInSeconds + timeOffset)
            return printDateFormatter.string(from: startDate)
        }
        return ""
    }
}
