//
//  TimeSpeedometerView.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/25/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class TimeSpeedometerView: UIView {

    @IBOutlet private var bgView: UIView!
    
    @IBOutlet weak var speedometer: MBCircularProgressBarView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TimeSpeedometer", owner: self, options: nil)
        bgView.frame = self.bounds
        addSubview(bgView)
        bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func fillSpeedometer(_ userData: UserData) {
        
        let isDarkMode = (traitCollection.userInterfaceStyle == .dark) ? true : false
        speedometer.fontColor = isDarkMode ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        if let login = userData.login {
            ParseTime().getLogTimeOf(.lastWeek, login: login) { (hours) in
                self.speedometer.value = hours ?? 0
            }
        } else {
             speedometer.value = 0
        }
    }
}
