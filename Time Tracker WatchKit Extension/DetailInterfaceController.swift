//
//  DetailInterfaceController.swift
//  Time Tracker WatchKit Extension
//
//  Created by Wladmir Edmar Silva Junior on 18/11/19.
//  Copyright © 2019 Wladmir Edmar Silva Junior. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {

    @IBOutlet weak var clockOutLabel: WKInterfaceLabel!
     @IBOutlet weak var clockInLabel: WKInterfaceLabel!
     
     override func awake(withContext context: Any?) {
         super.awake(withContext: context)
         
         // ["clockedIn":clockIns[rowIndex],"clockedOut":clockOuts[rowIndex]]
         
         if let dates = context as? [String:Date] {
             if let clockIn = dates["clockedIn"] {
                 if let clockOut = dates["clockedOut"] {
                     let formatter = DateFormatter()
                     formatter.dateFormat = "MMM d h:mma"
                     
                     clockInLabel.setText(formatter.string(from: clockIn))
                     clockOutLabel.setText(formatter.string(from: clockOut))
                 }
             }
         }
     }

}
