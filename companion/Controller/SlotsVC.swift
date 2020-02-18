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
    
    var valideSlots: [Slot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global(qos: .userInteractive).async {
            
            let semaphore = DispatchSemaphore(value: 0)
            
            for number in 0... {
                
                var allSlots: [Slot] = []
                API.shared.getSlots(fromPage: number) { (slots) in
                    
                    allSlots = slots
                    print("signal")
                    semaphore.signal()
                }
                print("wait")
                let _ = semaphore.wait(timeout: .distantFuture)
                
                if let (valideSlots, isAllSlots) = self.processingSlots(allSlots) {
                    print("add slots")
                    self.valideSlots += valideSlots
                    guard isAllSlots == false else { break }
                } else {
                    print("error")
                }
            }
            print("valideSlots", self.valideSlots)
        }
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func processingSlots(_ slots: [Slot]) -> (valideSlots: [Slot], isAllSlots: Bool)? {
        
        var valideSlots: [Slot] = []
        let currentDate = Date().timeIntervalSince1970
        
        for slot in slots {
            
            let startTime   = String(slot.beginAt?.split(separator: ".").first ?? "")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let startDate = dateFormatter.date(from: startTime)?.timeIntervalSince1970 {
                guard currentDate < startDate else { return (valideSlots, true) }
                
                valideSlots.append(slot)
            } else {
                return nil
            }
        }
        return (valideSlots, false)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension SlotsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension SlotsVC: UITableViewDelegate {
    
}

