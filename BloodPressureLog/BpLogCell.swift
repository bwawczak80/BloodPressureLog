//
//  BpLogCell.swift
//  BloodPressureLog
//
//  Created by Brian Wawczak on 4/20/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit
import WebKit

class BpLogCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var pulse: UILabel!
    
    @IBOutlet weak var systolic: UILabel!
    
    @IBOutlet weak var diastolic: UILabel!
    
    @IBOutlet weak var notes: UILabel!
    
    @IBOutlet weak var contentColor: UIView!
    
    func setUserLog(userBp: UserLog) {
        
        let bpmString = String(userBp.pulse)
        let diastolicString = String(userBp.diastolic)
        let systolicString = String(userBp.systolic)
        date.text = userBp.time
        pulse.text = bpmString
        systolic.text = systolicString
        diastolic.text = diastolicString
        notes.text = userBp.notes
        let indicator = userBp.indicator
        
        switch indicator {
        case 1:
            contentColor.backgroundColor = UIColor(named: "alertGreen")
        case 2:
            contentColor.backgroundColor = UIColor(named: "alertYellow")
        case 3:
            contentColor.backgroundColor = UIColor(named: "alertOrange")
        case 4:
            contentColor.backgroundColor = UIColor(named: "alertOrange")
        case 5:
            contentColor.backgroundColor = UIColor(named: "alertYellow")
        case 6:
            contentColor.backgroundColor = UIColor(named: "alertRed")
        
        default:
            contentColor.backgroundColor = UIColor(named: "alertGreen")
        }
        
    }
    
}
