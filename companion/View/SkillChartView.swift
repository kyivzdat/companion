//
//  SkillChartView.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/27/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import Charts

class SkillChartView: RadarChartView {

    let chartView = RadarChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        chartView.frame = self.bounds
        
        chartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(chartView)
        
        // Лінії від центру
        let isDarkMode = traitCollection.userInterfaceStyle == .dark ? true : false
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 5, weight: .bold) // Значення на краях графіка
        xAxis.labelTextColor = isDarkMode ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        xAxis.xOffset = -10
        xAxis.yOffset = -10
        xAxis.valueFormatter = IndexAxisValueFormatter(values: arrayOfTitlesOfSkills)

        chartView.webLineWidth = 1.5 // line from center
        chartView.innerWebLineWidth = 1.5 // line by circle
        chartView.webColor = .lightGray
        chartView.innerWebColor = .lightGray
        
        // Внутрішні перетинки по колу (градація)
        let yAxis = chartView.yAxis
        yAxis.labelCount = 4
        yAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        yAxis.drawLabelsEnabled = false
        yAxis.axisMinimum = 0 // Мінімальне доступне значення з якого починється масштабування
        
        chartView.legend.enabled = false
    }
    
    // MARK: - fillChart
    func fillChart(_ array: Any?) {
        
        struct SkillWithValue {
            let title: String
            let value: Double
        }
        
        guard let skills = array as? [Skill] else { return print("skills - nil") }
        
        var printSkill: [SkillWithValue] = []
        
        let arrayOfTitleWithoutLineBreak = arrayOfTitlesOfSkills.map({ $0.replacingOccurrences(of: "\n", with: " ")})
        for skill in arrayOfTitleWithoutLineBreak {
            
            var value: Double = 0
            if let levelOfSkill = skills.first(where: { $0.name == skill })?.level {
                value = Double(levelOfSkill)
            }
            let newSkill = SkillWithValue(title: skill, value: value)
            printSkill.append(newSkill)
        }
    
        
        let entries = printSkill.map({ RadarChartDataEntry(value: $0.value) })
        
        let skillDataSet = RadarChartDataSet(
            entries: entries
        )
        let data = RadarChartData(dataSets: [skillDataSet])

        chartView.data = data
        
        skillDataSet.lineWidth = 1
        skillDataSet.colors = [#colorLiteral(red: 0, green: 0.6800579429, blue: 0.6883652806, alpha: 1)]
        skillDataSet.fillColor = #colorLiteral(red: 0.002772599459, green: 0.7285055518, blue: 0.7355008125, alpha: 1)
        skillDataSet.drawFilledEnabled = true
        
        skillDataSet.valueTextColor = .clear
    }
}
