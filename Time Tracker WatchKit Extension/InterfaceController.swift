//
//  InterfaceController.swift
//  Time Tracker WatchKit Extension
//
//  Created by Wladmir Edmar Silva Junior on 18/11/19.
//  Copyright © 2019 Wladmir Edmar Silva Junior. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    // MARK: - PROPERTIES
    
    @IBOutlet weak var topLabel: WKInterfaceLabel!
    @IBOutlet weak var middleLabel: WKInterfaceLabel!
    @IBOutlet weak var inOutButton: WKInterfaceButton!
    
    var clockedIn = false
    var timer : Timer?
    
    // MARK: LIFECYCLE
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        super.willActivate()
        
        if UserDefaults.standard.value(forKey: "clockedIn") != nil {
            clockedIn = true
            if timer == nil {
                startTimer()
            }
        } else {
            clockedIn = false
        }
        updateUI()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - PRIVATE API
    
    func clockIn() {
        
        UserDefaults.standard.set(Date(), forKey: "clockedIn")
        UserDefaults.standard.synchronize()
        startTimer()
    }
    
    func clockOut() {
        timer?.invalidate()
        timer = nil
        
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            if var clockedIns = UserDefaults.standard.array(forKey: "clockedIns") as? [Date] {
                clockedIns.insert(clockedInDate, at: 0)
                 UserDefaults.standard.set(clockedIns, forKey: "clockedIns")
            } else {
                UserDefaults.standard.set([clockedInDate], forKey: "clockedIns")
            }
            
            if var clockedOuts = UserDefaults.standard.array(forKey: "clockedOuts") as? [Date] {
                clockedOuts.insert(Date(), at: 0)
                UserDefaults.standard.set(clockedOuts, forKey: "clockedOuts")
            } else {
                UserDefaults.standard.set([Date()], forKey: "clockedOuts")
            }
            
            UserDefaults.standard.set(nil, forKey: "clockedIn")
            UserDefaults.standard.synchronize()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.updateUI()
        }
    }
    
    func updateUI() {
        if clockedIn {
            topLabel.setHidden(false)
            topLabel.setText("Hoje: \(totalTimeWorkedAsString())")
            inOutButton.setTitle("I finished here!")
            inOutButton.setBackgroundColor(.red)
            if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
                let timeInterval = Int(Date().timeIntervalSince(clockedInDate))
                
                let hours = timeInterval / 3600
                let minutes = (timeInterval % 3600) / 60
                let seconds = timeInterval % 60
                
                var currentClockedInString = ""
                                
                currentClockedInString += "\(hours):"
                currentClockedInString += "\(minutes):"
                currentClockedInString += "\(seconds)"
                
                middleLabel.setText(currentClockedInString)
                
            }
        } else {
            topLabel.setHidden(true)
            inOutButton.setTitle("Go Horse!")
            inOutButton.setBackgroundColor(.green)
            middleLabel.setText("Vamos começar o trabalho!")
        }
    }
    
    func totalClockedTime() -> Int {
        if let clockedIns = UserDefaults.standard.array(forKey: "clockedIns") as? [Date] {
            if let clockedOuts = UserDefaults.standard.array(forKey: "clockedOuts") as? [Date] {
                var seconds = 0
                
                for index in 0..<clockedIns.count {
                    seconds += Int(clockedOuts[index].timeIntervalSince(clockedIns[index]))
                }
                
                return seconds
            }
        }
        return 0
    }
    
    func totalTimeWorkedAsString() -> String {
        var currentClockedInSeconds = 0
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            currentClockedInSeconds = Int(Date().timeIntervalSince(clockedInDate))
        }
        let totalTimeInterval = currentClockedInSeconds + totalClockedTime()
        let totalHours = totalTimeInterval / 3600
        let totalMinutes = (totalTimeInterval % 3600) / 60
        
        return "\(totalHours)h \(totalMinutes)m"
    }
    
    // MARK: - ACTIONS
    
    @IBAction func inOutTapped() {
        if clockedIn {
             clockOut()
         } else {
            clockIn()
         }
         clockedIn.toggle()
         updateUI()
    }
        
    @IBAction func historyTapped() {
        pushController(withName: "history", context: nil)
    }
    
    @IBAction func resetAllTapped() {
        UserDefaults.standard.set(nil, forKey: "clockedIn")
        UserDefaults.standard.set(nil, forKey: "clockedIns")
        UserDefaults.standard.set(nil, forKey: "clockedOuts")
        clockedIn = false
        updateUI()
    }
    
}
