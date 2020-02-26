//
//  Projects+Skills+AchievementsTVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/10/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import Kingfisher
import SVGKit
import Charts

class Projects_Skills_AchievementsTVC: UIViewController {
    
    enum TypeOfData: String {
        case projects
        case skills
        case achievements
    }
    
    @IBOutlet private weak var emptyImage:     UIImageView!
    @IBOutlet private weak var emptyLabel:     UILabel!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView:      UITableView!
    
    // Passed from prev VC
    var array:         [Any]!
    var getTypeOfData: TypeOfData!
    
    var poolDays:   [ProjectsUser] = []
    var iconsArray: [UIImage?] = []
    var printArray: [Any] = []
    var chartView = RadarChartView()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = getTypeOfData.rawValue.capitalized
        navigationItem.title = title

        
        
        if (array as? [Skill]) == nil || array.isEmpty {
            segmentControl.removeFromSuperview()
        } else {
            setupChartView()
        }
        
        printArray = array
        if printArray.isEmpty {
            emptyLabel.text = "No " + title
            emptyImage.isHidden = false
            emptyLabel.isHidden = false
        } else {
            iconsArray = Array<UIImage?>(repeating: nil, count: printArray.count)

            if let allProjects = printArray as? [ProjectsUser] {
                disperseProjects(allProjects)
            }
        }
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - viewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let frame = view.frame

        chartView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: frame.width,
                                 height: frame.height * 0.78)
        
        let center = view.center
        if UIDevice.current.orientation.isLandscape {
            chartView.center = CGPoint(x: center.x, y: center.y + 15)
        } else {
            chartView.center = CGPoint(x: center.x, y: center.y + 32)
        }
    }
    
    /**
     Disperse by projects and pool days
     */
    func disperseProjects(_ allProjects: [ProjectsUser]) {
        
        var projectArray: [ProjectsUser] = []
        allProjects.forEach { (project) in

            if project.project?.parentID == nil {
                projectArray.append(project)
            } else {
                poolDays.append(project)
            }
        }
        projectArray.sort(by: { ($0.currentTeamID ?? 0) > ($1.currentTeamID ?? 0) })
        printArray = projectArray
    }
    
    // MARK: - setupChartView
    func setupChartView() {
        chartView = RadarChartView()
        
        let isDarkMode = traitCollection.userInterfaceStyle == .dark ? true : false
        
        // Лінії від центру
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
        
        chartView.isHidden = true
        view.addSubview(chartView)
    }
    
    // MARK: - changedValueSegControl
    @IBAction func changedValueSegControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            printArray = array
            chartView.isHidden = true
        case 1:
            printArray = []
            fillChart()
            
        default:
            break
        }
        tableView.reloadData()
    }
    
    // MARK: - fillChart
    func fillChart() {
        
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
        
        chartView.isHidden = false
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToProjectTVC" {
            guard let dvc = segue.destination as? ProjectTVC,
                let projectToPass = sender as? ProjectsUser else { return print("Error. PrjSklAchvmntsTvC. prepare") }
            dvc.inputProjectUsers = projectToPass
            
            if let projectID = projectToPass.project?.id {
                
                var currentPoolDays: [ProjectsUser] = []
                poolDays.forEach { (project) in
                    if let parentID = project.project?.parentID, projectID == parentID {
                        currentPoolDays.append(project)
                    }
                }
                dvc.poolDays = currentPoolDays
            } else {
                dvc.poolDays = []
            }
        }
    }
    
}

extension Projects_Skills_AchievementsTVC: UITableViewDataSource {
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return printArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch getTypeOfData {
        case .projects:
            return getProjectCell(indexPath)
        case .skills:
            return getSkillCell(indexPath)
        case .achievements:
            return getAchievmentCell(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: getProjectCell
    func getProjectCell(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as? ProjectCell,
            let project = printArray[indexPath.row] as? ProjectsUser else { return UITableViewCell() }

        cell.fillProjectInfo(project)
        return cell
    }
    
    // MARK: getSkillCell
    func getSkillCell(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as? SkillCell,
            let skill = printArray[indexPath.row] as? Skill else { return UITableViewCell() }
        
        cell.skillLabel.text = skill.name
        if let level = skill.level {
            cell.valueLabel.text = String(level)
            cell.progressView.progress = level / 21
        }
        return cell
    }
    
    // MARK: getAchievmentCell
    func getAchievmentCell(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "achievementCell", for: indexPath) as? AchievementCell,
            let achievement = printArray[indexPath.row] as? Achievement else { return UITableViewCell() }
        
        cell.loadIconImage(image: iconsArray[indexPath.row], imageURLString: achievement.image) { newImage in
            self.iconsArray[indexPath.row] = newImage
        }
        cell.titleLabel.text = achievement.name
        cell.formatTierLable(achievement.tier)
        cell.descriptionLabel.text = achievement.achievementDescription
        
        return cell
    }
    
    // MARK: - heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch getTypeOfData {
        case .projects:
            return 50
        case .skills:
            return 55
        case .achievements:
            return 80
        default:
            return 0
        }
    }
}

extension Projects_Skills_AchievementsTVC: UITableViewDelegate {
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard getTypeOfData == TypeOfData.projects else { return }
        
        let selectedProject = printArray[indexPath.row]
        self.performSegue(withIdentifier: "segueToProjectTVC", sender: selectedProject)
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
