//
//  MonthCVCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/27/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import CenteredCollectionView

class MonthCVCell: UICollectionViewCell {
    
    @IBOutlet weak var calendarCV: UICollectionView!
    
    func fillCalendar() {

        calendarCV.delegate = self
        calendarCV.dataSource = self
    }
}


extension MonthCVCell: UICollectionViewDelegate {
    
}

extension MonthCVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let size = collectionView.frame.width / 7 - 7
        return CGSize(width: size, height: size)
    }
}

extension MonthCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        31
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = calendarCV.dequeueReusableCell(withReuseIdentifier:  "calendarCell", for: indexPath) as? CalendarCVCell else { return UICollectionViewCell() }

        cell.dateLabel.text = String(indexPath.row + 1)
        
        cell.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return cell
    }
    
    
    
}
