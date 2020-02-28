//
//  MonthsVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/27/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import CenteredCollectionView

class MonthsVC: UIViewController {
    
    @IBOutlet weak var monthsCV: UICollectionView!
    
    let cellPercentWidth: CGFloat = 0.8

    // A reference to the `CenteredCollectionViewFlowLayout`.
    // Must be aquired from the IBOutlet collectionView.
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredCollectionViewFlowLayout = monthsCV.collectionViewLayout as! CenteredCollectionViewFlowLayout

        monthsCV.decelerationRate = UIScrollView.DecelerationRate.fast
        
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: monthsCV.frame.width * cellPercentWidth + 10,
            height: monthsCV.frame.height * cellPercentWidth
        )

        // Configure the optional inter item spacing (OPTIONAL STEP)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 20

        // Get rid of scrolling indicators
        monthsCV.showsVerticalScrollIndicator = false
        monthsCV.showsHorizontalScrollIndicator = false


        monthsCV.delegate = self
        monthsCV.dataSource = self
    }
}

extension MonthsVC: UICollectionViewDelegate {
    
}

//extension MonthsVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let size = CGSize(width: monthsCV.frame.width - 20, height: monthsCV.frame.height - 20)
//        return size
//    }
//}

extension MonthsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = monthsCV.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath) as? MonthCVCell else { return UICollectionViewCell() }

        cell.fillCalendar()
        return cell
    }
}

