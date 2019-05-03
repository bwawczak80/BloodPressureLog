//
//  StatsViewController.swift
//  BloodPressureLog
//
//  Created by Brian Wawczak on 4/4/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit
import WebKit

class StatsViewController: UIViewController {

    @IBOutlet weak var totalNum: UILabel!
    
    @IBOutlet weak var avgSys: UILabel!
    
    @IBOutlet weak var avgDia: UILabel!
    
    @IBOutlet weak var pulsePressure: UILabel!
    var dataArray: [UserLog] = []
    
    var sysArray: [Int32] = []
    var diaArray: [Int32] = []
    var avgArray: [[Int32]] = []
    
    lazy var db = openDatabase()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avgArray = query()
        
        calculateAverages(avgArray: avgArray)
       
    }
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(dataFilePath(), &db) == SQLITE_OK {
            return db
        }else {
            print("Error opening database")
            sqlite3_close(db)
            return nil
        }
    }
    

    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url: String?
        url = ""  //create a blank path
        url = urls.first?.appendingPathComponent("data.plist").path
        return url!
    }
    
    
    func query() -> [[Int32]]{
        let queryStatementString = "SELECT * FROM LogTable;"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                
                let time = String(cString: sqlite3_column_text(queryStatement, 1))
                let sys =  sqlite3_column_int(queryStatement, 2)
                let dia =  sqlite3_column_int(queryStatement, 3)
                let bpm =  sqlite3_column_int(queryStatement, 4)
                let note = String(cString: sqlite3_column_text(queryStatement, 5))
                let indicator = sqlite3_column_int(queryStatement, 6)
                
                let log = UserLog(time: time, systolic: sys, diastolic: dia, pulse: bpm, notes: note, indicator: indicator)
                
                let sysNum = log.systolic
                let diaNum = log.diastolic
                
                sysArray.append(sysNum)
                diaArray.append(diaNum)
                avgArray = [sysArray, diaArray]
            }
            sqlite3_finalize(queryStatement)
            return avgArray
        }else {
            print("Query Error, Failed to retrieve data")
            return []
        }
        
    }
    
    func calculateAverages(avgArray: [[Int32]]){
        let sysArray = avgArray[0]
        let diaArray = avgArray[1]
        let sumSysArray = sysArray.reduce(0, +)
        let sumDiaArray = diaArray.reduce(0, +)
        let count = sysArray.count
        let avgSysValue = sumSysArray / Int32(count)
        let avgDiaValue = sumDiaArray / Int32(count)
        let avgPulsePressure = avgSysValue - avgDiaValue
        
        totalNum.text = String(count)
        avgSys.text = String(avgSysValue)
        avgDia.text = String(avgDiaValue)
        pulsePressure.text = String(avgPulsePressure)
        
    }
    
}
