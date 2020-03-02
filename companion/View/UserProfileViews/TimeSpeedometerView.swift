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
    
    @IBOutlet private weak var speedometer: MBCircularProgressBarView!
    
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
        speedometer.value = 0
        
        bgView.layer.cornerRadius = 3
        bgView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 1
        bgView.layer.shadowOpacity = 0.1
    }
    
    func fillSpeedometer(_ userData: UserData) {
        
        let isDarkMode = (traitCollection.userInterfaceStyle == .dark) ? true : false
        speedometer.fontColor = isDarkMode ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        if let login = userData.login {
            
            ParseTime().getLogTime(of: .lastWeek,
                                   login: login,
                                   returnWeekTime: { (hours) in
                                    UIView.animate(withDuration: 4) {
                                        self.speedometer.value = hours ?? 0
                                    }
            })
        }
    }
    
    func setSpeedometerFontColor(isDarkMode: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.speedometer.fontColor = isDarkMode ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}
