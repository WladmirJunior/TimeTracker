//
//  HistoryInterfaceController.swift
//  Time Tracker WatchKit Extension
//
//  Created by Wladmir Edmar Silva Junior on 18/11/19.
//  Copyright © 2019 Wladmir Edmar Silva Junior. All rights reserved.
//

import WatchKit

class HistoryInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    
    var clockIns = [Date]()
    var clockOuts = [Date]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let clockIns = UserDefaults.standard.array(forKey: "clockedIns") as? [Date] {
            self.clockIns = clockIns
        }
        if let clockOuts = UserDefaults.standard.array(forKey: "clockedOuts") as? [Date] {
            self.clockOuts = clockOuts
        }
        table.setNumberOfRows(clockIns.count, withRowType: "InOutRow")
        
        for index in 0..<clockIns.count {
            if let rowController = table.rowController(at: index) as? ClockInAndOutRowController {
                
                let timeInterval = Int(clockOuts[index].timeIntervalSince(clockIns[index]))
                
                let hours = timeInterval / 3600
                let minutes = (timeInterval % 3600) / 60
                let seconds = timeInterval % 60
                
                var currentClockedInString = ""
                
                if hours != 0 {
                    currentClockedInString += "\(hours)h "
                }
                if minutes != 0 || hours != 0 {
                    currentClockedInString += "\(minutes)m "
                }
                currentClockedInString += "\(seconds)s"
                
                rowController.label.setText(currentClockedInString)
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "timeDetail", context: ["clockedIn":clockIns[rowIndex],"clockedOut":clockOuts[rowIndex]])
    }
}
