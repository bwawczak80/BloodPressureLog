//
//  UserLog.swift
//  BloodPressureLog
//
//  Created by Brian Wawczak on 4/20/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import Foundation
import UIKit


class UserLog {
    
    var time: String
    var systolic: Int32
    var diastolic: Int32
    var pulse: Int32
    var notes: String
    
    
    init(time: String, systolic: Int32, diastolic: Int32, pulse: Int32, notes: String) {
        self.time = time
        self.systolic = systolic
        self.diastolic = diastolic
        self.pulse = pulse
        self.notes = notes
    }
}

