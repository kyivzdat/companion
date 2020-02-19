//
//  SlotsVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/18/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class SlotsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var slotsForPrint: [Slot] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var sectionNumber: [Int : Int] = [:]
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)

        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeRequestForSlots()
    }
    
    //2020-02-19T19:00:00.000Z
    // MARK: - defineSectionsNumber
    func defineSectionsNumber(_ slots: [Slot]) {
        
        sectionNumber = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var countForEachSection = 0
        var numberOfSection = 0
        var prevDate: Date? = nil
        
        for slot in slots {
            
            let slotDateStr = String((slot.beginAt?.split(separator: "T"))?.first ?? "nil")
            guard let slotDate = dateFormatter.date(from: slotDateStr) else { return }
            
            if prevDate == nil {
                prevDate = slotDate
            }
            
            if prevDate == slotDate {

                sectionNumber[numberOfSection] = countForEachSection
                countForEachSection += 1
            } else if let prevDate2 = prevDate, prevDate2 < slotDate {

                numberOfSection += 1
                prevDate = slotDate
                sectionNumber[numberOfSection] = 0
                
                countForEachSection = 1
            }
        }
    }
    
    // MARK: - showActivityIndicator
    func showActivityIndicator(isActive: Bool) {
        DispatchQueue.main.async {
            if isActive {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            self.activityIndicator.isHidden = isActive ? false : true
            UIApplication.shared.isNetworkActivityIndicatorVisible = isActive ? true : false
        }
    }
    
    // MARK: - makeRequestForSlots
    func makeRequestForSlots() {
        
        slotsForPrint = []
        sectionNumber = [:]
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.showActivityIndicator(isActive: true)
            
            let semaphore = DispatchSemaphore(value: 0)
            
            var valideSlots: [Slot] = []
            // Slots are placement on several json pages. We check all when we dont find current date
            for number in 1... {

                print("pages for slots -", number)
                if number % 2 == 0 {
                    print("sleep")
                    sleep(1)
                }
                
                var requestsSlots: [Slot]? = nil
                API.shared.getSlots(fromPage: number) { (slots) in
                    requestsSlots = slots
                    semaphore.signal()
                }
                let _ = semaphore.wait(timeout: .distantFuture)
                
                if let requestsSlots = requestsSlots, let (valideSlotsFromOneURLPage, isAllSlots) = self.processingSlots(requestsSlots) {

                    valideSlots += valideSlotsFromOneURLPage
                    guard isAllSlots == false else { break }
                } else {
                    self.showAlert()
                    self.showActivityIndicator(isActive: false)
                }
            }
            self.slotsForPrint = self.getSlotsForPrint(fromValidSlots: valideSlots)
            self.showActivityIndicator(isActive: false)
        }
    }
    
    func showAlert() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Something went wrong", message: "Try again later", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default)
            ac.addAction(okButton)
            self.present(ac, animated: true)
        }
    }
    
    // MARK: - processingSlots
    func processingSlots(_ slots: [Slot]) -> (valideSlots: [Slot], isAllSlots: Bool)? {
        
        var valideSlots: [Slot] = []
        let currentDate = Date().timeIntervalSince1970 + 15 * 60 // + 15 minute like in intra42
        
        for slot in slots {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let timeOffset = Double(TimeZone.current.secondsFromGMT())
            
            let startTime = String(slot.beginAt?.split(separator: ".").first ?? "")
            
            if var startDate = dateFormatter.date(from: startTime)?.timeIntervalSince1970 {
                startDate += timeOffset
                guard currentDate < startDate else { return (valideSlots, true) }
                
                valideSlots.append(slot)
            } else {
                return nil
            }
        }
        return (valideSlots, false)
    }
    
    // MARK: - getSlotsForPrint
    func getSlotsForPrint(fromValidSlots slots: [Slot]) -> [Slot] {
        
        func updateLastSlot(_ lastSlot: Slot, _ currentSlot: Slot) -> Slot {
            let updateLastSlot = Slot(id: nil,
                                        beginAt: currentSlot.beginAt,
                                        endAt: lastSlot.endAt,
                                        scaleTeam: lastSlot.scaleTeam)
            
            return updateLastSlot
        }
        
        var result: [Slot] = []
        for slot in slots {
            
            if slot.beginAt?.contains("2020-02-22T22:00:00.000Z") ?? false {
                print()
            }
            
            if result.isEmpty {
                result.append(slot)
            }
            
            if let lastSlot = result.last, lastSlot.beginAt == slot.endAt {
                if lastSlot.scaleTeam == nil && slot.scaleTeam == nil {
                    
//                    guard let beginDay = getDay(slot.beginAt), let endDay = getDay(slot.endAt) else { return [] }
                    
                    
                    if getDay(slot.beginAt, slot.endAt) == true {
                        result[result.endIndex - 1] = updateLastSlot(lastSlot, slot)
                    } else {
                        result.append(slot)
//                        print()
                    }
                    
                } else if lastSlot.scaleTeam == nil && slot.scaleTeam != nil {//if team has not be in lastSlot and just came
                        result.append(slot)
                } else { // if team have be
                    result[result.endIndex - 1] = updateLastSlot(lastSlot, slot)
                }
            } else if result.last?.id != slot.id {
                print("result.last?.id != slot.id")
                result.append(slot)
            }
        }
        result.reverse()
        defineSectionsNumber(result)
        return result
    }
    
    
    // TODO: - FIX
    /*
     {
       [40] = {
         id = nil
         beginAt = "2020-02-22T17:00:00.000Z"
         endAt = "2020-02-22T18:00:00.000Z"
         scaleTeam = nil
       }
       [41] = {
         id = nil
         beginAt = "2020-02-22T18:15:00.000Z"
         endAt = "2020-02-22T18:45:00.000Z"
         scaleTeam = nil
       }
       [42] = {
         id = nil
         beginAt = "2020-02-22T22:00:00.000Z"
         endAt = "2020-02-23T00:00:00.000Z"
         scaleTeam = nil
       }
       [43] = {
         id = nil
         beginAt = "2020-02-23T00:00:00.000Z"
         endAt = "2020-02-23T21:45:00.000Z"
         scaleTeam = nil
       }
     }
     
     */
    
    func getDay(_ start: String?, _ end: String?) -> Bool? {
        
        let getDate = DateFormatter()
        getDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let getDay = DateFormatter()
        getDay.dateFormat = "dd"
        
        let timeOffset = Double(TimeZone.current.secondsFromGMT())
        
        let correctStart = String(start?.split(separator: ".").first ?? "")
        let correctEnd = String(end?.split(separator: ".").first ?? "")
        
        if let startDate = getDate.date(from: correctStart),
            let endDate = getDate.date(from: correctEnd) {
            
            let startDay = getDay.string(from: startDate)
            let endDay = getDay.string(from: endDate)
            if let startDayDate = getDay.date(from: startDay)?.timeIntervalSince1970,
                let endDayDate = getDay.date(from: endDay)?.timeIntervalSince1970 {
                
                let startDateWithOffset = Date(timeIntervalSince1970: startDayDate + timeOffset)
                let endDateWithOffset = Date(timeIntervalSince1970: endDayDate + timeOffset)
                
                return startDateWithOffset == endDateWithOffset
            }
        }
        return nil
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    

}

extension SlotsVC: UITableViewDataSource {
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNumber.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let numberInSection = sectionNumber[section] {
            return numberInSection + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let printDateFormatter = DateFormatter()
        printDateFormatter.dateFormat = "MMMM dd"

        var prevDate: Date? = nil
        var count = 0
        
        for slot in slotsForPrint {
            let slotDateStr = String((slot.beginAt?.split(separator: "T"))?.first ?? "nil")
            guard let slotDate = dateFormatter.date(from: slotDateStr) else { return "" }
            
            if prevDate == nil {
                prevDate = slotDate
            }
            
            if let prevDate2 = prevDate, prevDate2 < slotDate {
                count += 1
                prevDate = slotDate
            }
            if count == section {
                return printDateFormatter.string(from: slotDate)
            }
        }
        return ""
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "slotCell", for: indexPath) as! SlotsTVCell
        
        var index = 0
        if indexPath.section != 0 {
            for i in 1..<indexPath.section {
                index += sectionNumber[i] ?? 0
            }
            index += indexPath.section
        }
        let slot = slotsForPrint[index + indexPath.row]

        cell.fillView(withSlot: slot)
        
        return cell
    }
}

extension SlotsVC: UITableViewDelegate {
    
}

