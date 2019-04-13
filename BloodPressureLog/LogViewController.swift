//
//  LogViewController.swift
//  BloodPressureLog
//
//  Created by Brian Wawczak on 4/4/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class LogViewController: UIViewController {

    
    @IBOutlet weak var systolic: UITextField!
    @IBOutlet weak var diastolic: UITextField!
    @IBOutlet weak var pulse: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var display: UILabel!
    
    var logArray:[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        let fileManager = FileManager.default
//
//        // create reference to SQLite database
//        var sqliteDB: OpaquePointer? = nil
//        var dbUrl: NSURL? = nil
//
//        //initiate database URL
//        do {
//            let baseURL = try
//                fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let dbUrl = baseURL.appendingPathComponent("swift.sqlite")
//        } catch {
//            print(error)
//        }
//
//        if let dbUrl = dbUrl {
//
//            let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
//            let status = sqlite3_open_v2(dbUrl.absoluteString?.cString(using: String.Encoding.utf8)!, &sqliteDB, flags, nil)
//
//            if status == SQLITE_OK {
//                let errMsg: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
//
//                let sqlStatement = "create table if not exists BPLogs (ID Integer Primary key AutoIncrement, Systolic Int, Diastolic Int, Pulse Int, Notes Text);"
//                if sqlite3_exec(sqliteDB, sqlStatement, nil, nil, errMsg) == SQLITE_OK {
//                    print("created table")
//                }else {
//                    print("failed to create table")
//                }
//
//                // create insert statement
//
//                //TODO https://www.youtube.com/watch?v=8wc723Wt8wQ  at 7:53
//
//                var statement: COpaquePointer = nil
//                let insert
//            }
//
//
//        }
        
        display.isHidden = true
        timeStamp.text = getTimeStamp()
        
    }
    
    @IBAction func logBP(_ sender: Any) {
        
        if validateData(systolic.text ?? "", diastolic.text ?? "", pulse.text ?? "") {
        let systolicInput = Int(systolic.text!)
        let diastolicInput = Int(diastolic.text!)
        let pulseInput = Int(pulse.text!)
        let notesInput = notes.text ?? "None"
        let warningLabel = calculateBpWarning(systolicInput!, diastolicInput!)
        display.isHidden = false
        display.text = "Blood Pressure: \(systolicInput!) / \(diastolicInput!)\nPulse: \(pulseInput!)\n Notes: \(notesInput)"
        timeStamp.text = getTimeStamp()
            switch(warningLabel){
            case 1:
                display.text = "Your Blood Pressure is normal"
                display.backgroundColor = .green
                break;
            case 2:
                display.text = "Your Blood Pressure is Elevated"
                display.backgroundColor = .yellow
                break;
            case 3:
                display.text = "Your Blood Pressure indicates Stage 1 Hypertension"
                display.backgroundColor = .orange
                break;
            case 4:
                display.text = "Your Blood Pressure indidcates State 3 Hypertension"
                display.backgroundColor = .orange
            case 5:
                display.text = "Your Blood Pressure is Low"
                display.backgroundColor = .yellow
                break;
            case 6:
                display.text = "Your Blood Pressure indicates a Hypertensive Crisis.  Please seek medical assistance!"
                display.backgroundColor = .red
            default:
                display.text = "Please enter a valid number"
                
            }
        }
        else{
            errorMessage()
        }
    }
    
    // checks that systolic, diastolic, and pulse entries are not empty, and can be parsed to an Int.
    func validateData(_ systolic: String,_ diastolic: String,_ pulse: String) -> Bool {
        let systolicInt = Int(systolic)
        let diastolicInt = Int(diastolic)
        let pulseInt = Int(pulse)
        guard systolic.isEmpty == false, (systolic.count) >= 2, (systolic.count) <= 3 else {
            return false
        }
        guard diastolic.isEmpty == false, (diastolic.count) >= 2, (diastolic.count) <= 3 else {
            return false
        }
        guard pulse.isEmpty == false, (pulse.count) >= 2, (pulse.count) <= 3 else {
            return false
        }
        
        guard pulseInt != nil else {
            return false
        }
        
        guard systolicInt != nil else {
            return false
        }
        guard diastolicInt != nil else {
            return false
        }
        guard systolicInt! < 500 && diastolicInt! < 300 else {
            return false
        }
        
        return true
    }
    
    func errorMessage() {
        let invalidDataAlert = UIAlertController(title: "invalid Data", message: "Please check your numbers and try again.", preferredStyle: .alert)
        invalidDataAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(invalidDataAlert, animated: true)
    }
    
    
    func calculateBpWarning (_ sys: Int,_ dia: Int) -> Int {
        if sys < 120 && dia < 80 && sys >= 100 && dia >= 60 {
            return 1 //"Your Blood Pressure is Normal"
        }else if sys >= 120 && sys < 130 && dia <= 80 || sys < 120 && dia <= 80 {
            return 2 // "Your Blood Pressure is Elevated"
        }else if sys >= 130 && sys < 140 && dia < 89 || dia > 80 && dia < 89 {
            return 3 // "You have stage 1 hypertension"
        }else if sys >= 140 && sys < 180 && dia < 120 || dia >= 90 && dia < 120 {
            return 4 // "You have stage 2 hypertension"
        }else if sys < 120 && dia < 80 {
            return 5 // "Your Blood Pressure is Low"
        }else if sys >= 180 || dia >= 120 {
            return 6  //"You are in a Hypertensive Crisis"
        }else{
            return 7  // "Please Enter a valid Numnber"
        }
    }
    
    func getTimeStamp() -> String {
        let currentDate = Date()
        let currentCalendar = Calendar.current
        let currentDateDetails: DateComponents = currentCalendar.dateComponents(in: currentCalendar.timeZone, from: currentDate)
        let day = currentDateDetails.day
        let year = currentDateDetails.year
        let thisMonth = currentCalendar.component(.month, from: currentDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        let timeNow = formatter.string(from: currentDate)
        let dateTimeStamp = "\(thisMonth)/\(day ?? 0)/\(year ?? 0) \(timeNow)"
        
        return dateTimeStamp
        
            }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
