//
//  SlotsVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/18/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class SlotsVC: UITableViewController {
    
    var slotsForPrint: [Slot] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var pullToRefreshControl: UIRefreshControl {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }
    
    var sectionNumber: [Int : (number: Int, date: String)] = [:]
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.visibleViewController?.title = "Slots"
        
        makeRequestForSlots() {}
        
        tableView.refreshControl = pullToRefreshControl
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        
        makeRequestForSlots {
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
        }
    }
    
    // MARK: - showActivityIndicator
    func showActivityIndicator(isActive: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isActive ? true : false
        }
    }
    
    // MARK: - makeRequestForSlots
    func makeRequestForSlots(completion: @escaping () -> ()) {
        
        // Getting Evaluation Slots
        sectionNumber = [:]
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.showActivityIndicator(isActive: true)
            
            let semaphore = DispatchSemaphore(value: 0)
            
            var valideSlots: [Slot] = []
            // Slots are placement on several json pages. We check all when we dont find current date
            for number in 1... {
                
                print("pages for slots -", number)
                if number % 2 == 0 {
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
                    completion()
                    return
                }
            }
            if let slotsForPring = self.getSlotsForPrint(fromValidSlots: valideSlots) {
                self.slotsForPrint = slotsForPring
            } else {
                self.showAlert()
                completion()
                return
            }
            completion()
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
    func getSlotsForPrint(fromValidSlots slots: [Slot]) -> [Slot]? {
        
        func updateLastSlot(_ lastSlot: Slot, _ currentSlot: Slot) -> Slot {
            let updateLastSlot = Slot(id: nil,
                                      beginAt: currentSlot.beginAt,
                                      endAt: lastSlot.endAt,
                                      scaleTeam: lastSlot.scaleTeam)
            return updateLastSlot
        }
        
        var result: [Slot] = []
        for slot in slots {
            
            if result.isEmpty {
                result.append(slot)
            }
            
            // if it's same slot separated by 15 minutes
            if let lastSlot = result.last, lastSlot.beginAt == slot.endAt {
                // if no evaluation
                if lastSlot.scaleTeam == nil && slot.scaleTeam == nil {
                    
                    // Handle if its placed (21:45 - 00:00), it will be (23:45 - 00:00) and (00:00 - 02:00) + 2 UTC
                    if isTheSameSlot(slot.beginAt, slot.endAt) == true {
                        result[result.endIndex - 1] = updateLastSlot(lastSlot, slot)
                    } else {
                        result.append(slot)
                    }
                    
                // else if evaluation has not be in lastSlot and just came
                } else if lastSlot.scaleTeam == nil && slot.scaleTeam != nil {
                    result.append(slot)
                    
                // else if evaluation have be
                } else {
                    result[result.endIndex - 1] = updateLastSlot(lastSlot, slot)
                }
                
            // else if it's another slot
            } else if result.last?.id != slot.id {
                result.append(slot)
            }
        }
        result.reverse()
        if defineSectionsNumber(result) {
            return result
        }
        return nil
    }
    
    // MARK: isTheSameSlot
    func isTheSameSlot(_ start: String?, _ end: String?) -> Bool? {
        
        let getDate = DateFormatter()
        getDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let getDay = DateFormatter()
        getDay.dateFormat = "dd"
        
        let timeOffset = Double(TimeZone.current.secondsFromGMT())
        
        let correctStart = String(start?.split(separator: ".").first ?? "")
        let correctEnd = String(end?.split(separator: ".").first ?? "")
        
        if let startDate = getDate.date(from: correctStart)?.timeIntervalSince1970,
            let endDate = getDate.date(from: correctEnd)?.timeIntervalSince1970 {
            
            let startDateWithOffset = Date(timeIntervalSince1970: startDate + timeOffset)
            let endDateWithOffset = Date(timeIntervalSince1970: endDate + timeOffset)
            
            let startDayDate = getDay.string(from: startDateWithOffset)
            let endDayDate = getDay.string(from: endDateWithOffset)
            
            return startDayDate == endDayDate
        }
        return nil
    }
    
    // MARK: - defineSectionsNumber
    func defineSectionsNumber(_ slots: [Slot]) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let printDateFormatter = DateFormatter()
        printDateFormatter.dateFormat = "MMMM dd"
        
        let timeOffset = Double(TimeZone.current.secondsFromGMT())
        
        var countForEachSection = 0
        var numberOfSection = 0
        var prevDate: Date? = nil
        
        for slot in slots {
            
            let slotDateStr = String((slot.beginAt?.split(separator: "."))?.first ?? "nil")
            guard let slotDate = dateFormatter.date(from: slotDateStr)?.timeIntervalSince1970 else { return false }
            let slotDateWithOffset = Date(timeIntervalSince1970: slotDate + timeOffset)
            
            let dateForPrint = printDateFormatter.string(from: slotDateWithOffset)
            guard let dateForCompare = printDateFormatter.date(from: dateForPrint) else { return false }
            
            if prevDate == nil {
                prevDate = dateForCompare
            }
            
            if prevDate == dateForCompare {
                
                countForEachSection += 1
                sectionNumber[numberOfSection] = (countForEachSection, dateForPrint)
            } else if let prevDate2 = prevDate, prevDate2 < dateForCompare {
                
                prevDate = dateForCompare
                numberOfSection += 1
                
                countForEachSection = 1
                sectionNumber[numberOfSection] = (countForEachSection, dateForPrint)
            }
        }
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    
}

extension SlotsVC {
    
    // MARK: - TableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNumber.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let numberInSection = sectionNumber[section]?.number {
            return numberInSection
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let date = sectionNumber[section]?.date {
            return date
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "slotCell", for: indexPath) as! SlotsTVCell
        
        var index = 0
        if indexPath.section != 0 {
            for i in 0..<indexPath.section {
                index += sectionNumber[i]?.number ?? 0
            }
        }
        let slot = slotsForPrint[index + indexPath.row]
        
        cell.fillView(withSlot: slot)
        
        return cell
    }
}
