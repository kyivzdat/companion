//
//  MainInfoView.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/25/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class MainInfoView: UIView {
    
    @IBOutlet private var bgView: UIView!
    
    @IBOutlet private weak var photoView: UIImageView!
     
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var login: UILabel!
    
    @IBOutlet private weak var correctionPoints: UILabel!
    @IBOutlet private weak var wallet: UILabel!
    @IBOutlet private weak var poolYear: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MainInfoView", owner: self, options: nil)
        bgView.frame = self.bounds
        addSubview(bgView)
        bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        bgView.layer.cornerRadius = 3
        bgView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 1
        bgView.layer.shadowOpacity = 0.1
    }

    // MARK: - fillMainInfo
    func fillMainInfo(_ userData: UserData) {
                if let urlImage = URL(string: userData.imageURL ?? "") {
            photoView.layer.cornerRadius = 3
            photoView.kf.indicatorType = .activity
            photoView.kf.setImage(with: urlImage,
                                       placeholder: #imageLiteral(resourceName: "photoHolder"),
                                       options: [.transition(.fade(1))],
                                       progressBlock: nil)
        }

        fullName.text = userData.displayname
        login.text = userData.login
        correctionPoints.text = String(userData.correctionPoint ?? 0)
        wallet.text = String(userData.wallet ?? 0) + " ₳"
        if let poolMonth = userData.poolMonth, let poolYearData = userData.poolYear {
            poolYear.text = poolMonth + ", " + poolYearData
        }
    }
}
