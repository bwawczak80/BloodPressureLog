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
    
    var date: String
    var pulse: String
    var systolic: String
    var diastolic: String
    var notes: String
    
    init(date: String, pulse: String, systolic: String, diastolic: String, notes: String) {
        self.date = date
        self.pulse = pulse
        self.systolic = systolic
        self.diastolic = diastolic
        self.notes = notes
    }
}

