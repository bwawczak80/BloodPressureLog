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
    
    
    @IBOutlet var lineFields:[UITextField]!
    
    var logArray:[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // get path to database file
        
        var database: OpaquePointer? = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        // create sql table to hold data if none exists
        let createSQL = "CREATE TABLE IF NOT EXISTS FIELDS " + "(ROW INTEGER PRIMARY KEY, FIELD_DATA TEXT);"
        
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        result = sqlite3_exec(database, createSQL, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        }
        
        // select data
        let query = "SELECT ROW, FIELD_DATA FROM FIELDS ORDER BY ROW"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let row = Int(sqlite3_column_int(statement, 0))
                let rowData = sqlite3_column_text(statement, 1)
                let fieldValue = String(cString: rowData!)
                lineFields[row].text = fieldValue
            }
            
            // close database connection
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name: UIApplication.willResignActiveNotification, object: app)
        
        

        
        display.isHidden = true
        timeStamp.text = getTimeStamp()
        
    }
    
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url: String?
        url = ""  //create a blank path
        url = urls.first?.appendingPathComponent("data.plist").path
        return url!
    }
    
    @objc func applicationWillResignActive(notification:NSNotification) {
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        // loops through the four fields and update each row of the database
        for i in 0..<lineFields.count {
            let field = lineFields[i]
            
            
            let update = "INSERT OR REPLACE INTO FIELDS (ROW, FIELD_DATA) " + "VALUES (?, ?);"
            var statement:OpaquePointer? = nil
            if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
                let text = field.text
                sqlite3_bind_int(statement, 1, Int32(i))
                
                sqlite3_bind_text(statement, 2, text!, -1, nil)
            }
            
            // execute the data update and finalize the statement
            if sqlite3_step(statement) != SQLITE_DONE {
                print ("Error updating table")
                sqlite3_close(database)
                return
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        
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
