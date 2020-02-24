//
//  UserProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/5/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import Kingfisher
import MBCircularProgressBar

class UserProfileVC: UITableViewController {
    
    // MARK: - Outlets
    // Main info outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var correctionPoints: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var yearOfpool: UILabel!
    
    // Location outlet
    @IBOutlet weak var isAvailableLabel: UILabel!
    
    // Internship, exams, level outlets
    @IBOutlet var internshipImageViews: Array<UIImageView>!
    @IBOutlet var examsImageViews: Array<UIImageView>!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelProgressView: UIProgressView!
    
    // TimeLog
    @IBOutlet weak var timeSpeedometer: MBCircularProgressBarView!
    
    // All bg views
    @IBOutlet var bgViews: Array<UIView>!
    
    // Passed Data from Login VC
    var userData: UserData!
    var titleText: String!
    var pullToRefresh: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }
    
    // MARK: - view Did load
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.visibleViewController?.title = titleText

        setupSearchController()
        viewSetup()
        
        fillViewWithInfo()
    }
    
    func fillViewWithInfo() {
        
        fillGeneralDataOnView()
        
        // Level
        fillLevelProgressView()
        
        // Exams
        managedExamsImages()
        
        // Internships
        checkForPassedInternships()
        
        makeRequestForTimeLog()
    }
    
    // MARK: - makeRequestForTimeLog
    func makeRequestForTimeLog() {

        guard let login = userData.login else { return print("makeRequestForTimeLog no login") }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let semaphore = DispatchSemaphore(value: 0)
            
            var rowTimeLog: [TimeLog]?
            
            API.shared.getTimeLog(login, page: 1) { (timeLogs) in
                rowTimeLog = timeLogs
                semaphore.signal()
            }
            let _ = semaphore.wait(timeout: .distantFuture)
            
            if let rowTimeLog = rowTimeLog {
                guard let weekTime = self.getTimeLogsForOneWeek(fromTimeLogs: rowTimeLog) else { return }
                var summa: Double = 0
                
                for index in 0..<weekTime.count {
                    guard index > 0 else { continue }
                    summa += weekTime[index].time
                }
                DispatchQueue.main.async {
                    self.timeSpeedometer.value = CGFloat(summa / 60 / 60)
                }
                print("hours -", summa / 60 / 60)
            }
        }
    }
    
    struct TimeForDay {
        let day: Date!
        let dayStr: String!
        var time: Double = 0
    }
    
    func getTimeLogsForOneWeek(fromTimeLogs timeLogs: [TimeLog]) -> [TimeForDay]? {
        
        let getDateFormatter = DateFormatter()
        getDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // 7 days ago
        let stopTime = Date().timeIntervalSince1970 - (8 * 24 * 60 * 60)

        var printTimeLog: [TimeForDay] = []
        
        var prevDate: Date? = nil
        for timeLog in timeLogs {

            guard let dayDate = getOnlyDay(fromString: timeLog.beginAt)
                else { return nil }
            
            // Check if we have reached all 7 days
            guard dayDate.timeIntervalSince1970 > stopTime else { break }
            
            // If first iteration
            if prevDate == nil {
                if let beginAt = timeLog.beginAt?.split(separator: ".").first,
                    let beginDate = getDateFormatter.date(from: String(beginAt)) {
                    let time = Date().timeIntervalSince1970 - Double(beginDate.timeIntervalSince1970) - Double(TimeZone.current.secondsFromGMT())
                    
                    let newDate = TimeForDay(day: dayDate, dayStr: getDateFormatter.string(from: dayDate), time: time)
                    
                    printTimeLog.append(newDate)
                    prevDate = dayDate
                    continue
                }
                
            }
            
            if prevDate == dayDate {
                
                if let beginAt = timeLog.beginAt?.split(separator: ".").first,
                    let endAt = timeLog.endAt?.split(separator: ".").first,
                    let beginTime = getDateFormatter.date(from: String(beginAt)), let endTime = getDateFormatter.date(from: String(endAt)) {
                    
                    let timeOfRange = endTime.timeIntervalSince1970 - beginTime.timeIntervalSince1970
                    printTimeLog[printTimeLog.endIndex - 1].time += timeOfRange
                } else {
                    print("Error")
                    return nil
                }
                
                //                correctTimeLog[correctTimeLog.endIndex - 1].beginAt = timeLog.beginAt
            } else {

                prevDate = dayDate
                if let beginAt = timeLog.beginAt?.split(separator: ".").first,
                    let endAt = timeLog.endAt?.split(separator: ".").first,
                    let beginTime = getDateFormatter.date(from: String(beginAt)),
                    let endTime = getDateFormatter.date(from: String(endAt)) {
                    
                    let timeOfRange = endTime.timeIntervalSince1970 - beginTime.timeIntervalSince1970
                    let newDate = TimeForDay(day: dayDate, dayStr: getDateFormatter.string(from: dayDate), time: timeOfRange)
                    printTimeLog.append(newDate)
                } else {
                    print("Error")
                    return nil
                }

                
                //                correctTimeLog.append(timeLog)
            }
        }
        return printTimeLog
    }
    
    /*
     String 2020-02-22T19:41:27.000Z
     String 2020-02-22T19:41:27
     DATE   2020-02-22T21:41:27
     String 2020-02-22
     DATE   2020-02-22
     */
    
    func getOnlyDay(fromString string: String?) -> Date? {
        
        let getDateFormatter = DateFormatter()
        getDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        getDateFormatter.timeZone = TimeZone.current
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let beginAtTimeLog = String(string?.split(separator: ".").first ?? "")
        guard let beginDateTimeLog = getDateFormatter.date(from: beginAtTimeLog)
            else { return nil }
        
        let dayTimeLog = dayDateFormatter.string(from: beginDateTimeLog)
        if let dayDateTimeLog = dayDateFormatter.date(from: dayTimeLog) {
            return dayDateTimeLog
        }
        return nil
    }
    
    // MARK: setupSearchController
    func setupSearchController() {
        guard let searchTVC = storyboard?.instantiateViewController(withIdentifier: "SearchTVC") as? SearchTVC else { return }
        
        searchTVC.parentTVC = self
        
        let searchController = UISearchController(searchResultsController: searchTVC)
        
        searchController.searchBar.placeholder = "Search a user"
        searchController.searchResultsUpdater = searchTVC
        searchController.searchBar.delegate = searchTVC
        
        navigationItem.searchController = searchController
    }
    
    // MARK:  fillGeneralDataOnView
    func fillGeneralDataOnView() {
        //Image
        if let urlImage = URL(string: userData.imageURL ?? "") {
            photoImageView.layer.cornerRadius = 3
            photoImageView.kf.indicatorType = .activity
            photoImageView.kf.setImage(with: urlImage,
                                       placeholder: #imageLiteral(resourceName: "photoHolder"),
                                       options: [.transition(.fade(1))],
                                       progressBlock: nil)
        }
        
        fullName.text = userData.displayname
        login.text = userData.login
        correctionPoints.text = String(userData.correctionPoint ?? 0)
        wallet.text = String(userData.wallet ?? 0) + " ₳"
        if let poolMonth = userData.poolMonth, let poolYear = userData.poolYear {
            yearOfpool.text = poolMonth + ", " + poolYear
        }
        isAvailableLabel.text = userData.location ?? "Unavailable"
    }
    
    // MARK: viewSetup
    func viewSetup() {
        bgViews.forEach { (view) in
            view.layer.cornerRadius = 3
            view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowRadius = 1
            view.layer.shadowOpacity = 0.1
        }
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.refreshControl = pullToRefresh
    }
    
    // MARK: fillLevelProgressView
    func fillLevelProgressView() {
        levelProgressView.layer.cornerRadius = 1
        levelProgressView.transform = .identity
        levelProgressView.transform = levelProgressView.transform.scaledBy(x: 1, y: 14)
        levelProgressView.clipsToBounds = true
        levelProgressView.tintColor = #colorLiteral(red: 0.002772599459, green: 0.7285055518, blue: 0.7355008125, alpha: 1)
        
        if let indexOfCursus = userData.cursusUsers?.firstIndex(where: { $0.cursusID == 1 }),
            let level = userData.cursusUsers?[indexOfCursus].level {
            
            let progress = Float(Double(level) - Double(Int(level)))
            levelLabel.text = "level "+String(Int(level))+" - "+String(Int((progress * 100).rounded()))+"%"
            
            levelProgressView.progress = progress
        } else {
            levelLabel.text = "level 0 - 0%"
            levelProgressView.progress = 0
        }
    }
    
    // MARK: managedExamsImages
    func managedExamsImages() {
        if let indexOfExams = userData.projectsUsers?.firstIndex(where: { $0.project?.id == 11 }),
            let exams = self.userData.projectsUsers?[indexOfExams] {
            
            let passedImage = #imageLiteral(resourceName: "passedExam")
            
            if exams.validated == true {
                examsImageViews.forEach { (examViewImage) in
                    examViewImage.image = passedImage
                }
            } else {
                var counter = 0
                exams.teams?.forEach({ (team) in
                    if team.validated == true {
                        examsImageViews[counter].image = passedImage
                        counter += 1
                    }
                })
            }
        }
    }
    
    // MARK: checkForPassedInternships
    func checkForPassedInternships() {
        
        for imageID in 0..<internshipImageViews.count {
            let idOfInternshipsProject = [120, 1650, 212] // First Internship, PartTime-I, Final Intership
            if let indexOfFinalInternShip = userData.projectsUsers?.firstIndex(where: { $0.project?.id == idOfInternshipsProject[imageID] }),
                self.userData.projectsUsers?[indexOfFinalInternShip].validated == true {
                
                self.internshipImageViews[imageID].image = #imageLiteral(resourceName: "internshipPassed")
            }
        }
    }
    
    // MARK: - refresh
    @objc func refresh(_ sender: UIRefreshControl) {
        
        if let login = userData.login {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            API.shared.getProfileInfo(userLogin: login) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let userData):
                        self.userData = userData
                        self.fillViewWithInfo()
                    case .failure(let error):
                        print("Failed to fetch self info: ", error)
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    sender.endRefreshing()
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToProjectSkillAchTVC" {
            
            typealias AllowedTypes = Projects_Skills_AchievementsTVC.TypeOfData
            
            guard let dvc = segue.destination as? Projects_Skills_AchievementsTVC,
                let tuple = sender as? (data: [Any], type: AllowedTypes) else { return print("Error. UserProfileVC. Prepare error casting") }
            
            dvc.array = tuple.data
            dvc.getTypeOfData = tuple.type
        }
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseID = 1
        
        var dataToPass: [Any] = []
        
        if indexPath.section == 1 {
            typealias AllowedTypes = Projects_Skills_AchievementsTVC.TypeOfData
            var typeOfData: AllowedTypes!
            switch indexPath.row {
            case 0:
                dataToPass = prepareProjects(courseID)
                typeOfData = .projects
            case 1:
                dataToPass = prepareSkills(courseID)
                typeOfData = .skills
            case 2:
                dataToPass = prepareAchievements(courseID)
                typeOfData = .achievements
            default:
                return
            }
            performSegue(withIdentifier: "segueToProjectSkillAchTVC", sender: (dataToPass, typeOfData))
        }
    }
    
    // MARK: - prepareProjects
    /**
     - course ID:
         - 4 - Piscine C  (pool)
         - 1 - school 42
     */
    func prepareProjects(_ courseID: Int) -> [ProjectsUser] {
        guard let projects = userData.projectsUsers else { return [] }
        var resultArray: [ProjectsUser] = []
        projects.forEach { (project) in
            // if project in school 42 and it's not pool
            if let ids = project.cursusIDS?.first, ids == courseID && project.project?.name != "Rushes" {
                resultArray.append(project)
            }
        }
        resultArray.sort(by: { ($0.currentTeamID ?? 0) > ($1.currentTeamID ?? 0) })
        return resultArray
    }
    
    // MARK: - prepareSkills
    func prepareSkills(_ courseID: Int) -> [Skill] {
        
        guard let indexOfCursus = userData.cursusUsers?.firstIndex(where: { $0.cursusID == courseID }),
            let skills = userData.cursusUsers?[indexOfCursus].skills else { return [] }
        return skills
    }
    
    // MARK: - prepareAchievements
    func prepareAchievements(_ courseID: Int) -> [Achievement] {
        
        var resultArray: [Achievement] = []
        guard let achievements = userData.achievements else { return [] }
        
        if achievements.isEmpty {
            return []
        }
        for i in 0..<(achievements.count - 1) {
            if achievements[i].name != achievements[i + 1].name {
                resultArray.append(achievements[i])
            }
        }
        if resultArray.last?.name != achievements.last?.name, let lastElem = achievements.last {
            resultArray.append(lastElem)
        }
        return resultArray
    }
}
