//
//  BpLogCell.swift
//  BloodPressureLog
//
//  Created by Brian Wawczak on 4/20/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit

class BpLogCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var pulse: UILabel!
    
    @IBOutlet weak var systolic: UILabel!
    
    @IBOutlet weak var diastolic: UILabel!
    
    @IBOutlet weak var notes: UILabel!
    
    func setUserLog(userBp: UserLog) {
        date.text = userBp.date
        pulse.text = userBp.pulse
        systolic.text = userBp.systolic
        diastolic.text = userBp.diastolic
        notes.text = userBp.notes
    }
    
}
