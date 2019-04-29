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
    
    func setUserLog(userBp: UserLog) {
        
        let bpmString = String(userBp.pulse)
        let diastolicString = String(userBp.diastolic)
        let systolicString = String(userBp.systolic)
        date.text = userBp.time
        
        pulse.text = bpmString
        
        systolic.text = systolicString
        
        diastolic.text = diastolicString
        
        notes.text = userBp.notes
    }
    
}
