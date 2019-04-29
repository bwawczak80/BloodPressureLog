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
import WebKit
import SQLite3

class LogViewController: UIViewController {
    
    @IBOutlet weak var systolic: UITextField!
    @IBOutlet weak var diastolic: UITextField!
    @IBOutlet weak var pulse: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var display: UILabel!
    
    
    @IBOutlet var lineFields:[UITextField]!
    
    var logArray:[Any] = []
    
    lazy var db = openDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display.isHidden = true
        timeStamp.text = getTimeStamp()
        createTable()
    }
    
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url: String?
        url = ""  //create a blank path
        url = urls.first?.appendingPathComponent("data.plist").path
        return url!
    }
    
    
    @IBAction func logBP(_ sender: Any) {
        let time = getTimeStamp()
        if validateData(systolic.text ?? "", diastolic.text ?? "", pulse.text ?? "") {
            let systolicInput = Int32(systolic.text!)
            let diastolicInput = Int32(diastolic.text!)
            let pulseInput = Int32(pulse.text!)
            let notesInput = notes.text ?? "None"
            let warningLabel = calculateBpWarning(Int(systolicInput!), Int(diastolicInput!))
            logArray = [time, systolicInput ?? 0, diastolicInput ?? 0, pulseInput ?? 0, notesInput]
            
            insert(logArray)
            
            systolic.text = ""
            diastolic.text = ""
            pulse.text = ""
            notes.text = ""
            
            display.isHidden = false
            timeStamp.text = time
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
                display.text = "Your Blood Pressure indidcates Stage 3 Hypertension"
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
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(dataFilePath(), &db) == SQLITE_OK {
            return db
        }else {
            sqlite3_close(db)
            return nil
        }
    }
    
    func createTable() {
        let createTableString = """

CREATE TABLE IF NOT EXISTS LogTable(
Id INTEGER PRIMARY KEY AUTOINCREMENT,
Time TEXT,
Systolic INTEGER,
Diastolic INTEGER,
BPM INTEGER,
Notes TEXT);
"""
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Contact table created")
            } else {
                print("Log table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(_ logArray: [Any]) {
        let insertStatementString = "INSERT INTO LogTable (Time, Systolic, Diastolic, BPM, Notes) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let time: NSString = logArray[0] as! NSString
            let systolic: Int32 = logArray[1] as! Int32
            let diastolic: Int32 = logArray[2] as! Int32
            let bpm: Int32 = logArray[3] as! Int32
            let notes: NSString = logArray[4] as! NSString
            
            sqlite3_bind_text(insertStatement, 1, time.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, systolic)
            sqlite3_bind_int(insertStatement, 3, diastolic)
            sqlite3_bind_int(insertStatement, 4, bpm)
            sqlite3_bind_text(insertStatement, 5, notes.utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
    }
    
}
