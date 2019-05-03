//
//  HistoryViewController.swift
//  BloodPressureLog
//
//  Created by Brian Wawczak on 4/4/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit
import WebKit

class HistoryViewController: UIViewController {
    
    lazy var db = openDatabase()
    
    @IBOutlet weak var tableView: UITableView!
    var dataArray: [UserLog] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        dataArray = query()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
       tableView.reloadData()
    }
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let title = "Open Error"
        let message = "Error opening database"
        if sqlite3_open(dataFilePath(), &db) == SQLITE_OK {
            return db
        }else {
            sqlError(title, message)
            sqlite3_close(db)
            return nil
        }
    }
    
    func sqlError(_ title: String, _ message: String) {
        let sqlAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        sqlAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(sqlAlert, animated: true)
    }
    
    
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url: String?
        url = ""  //create a blank path
        url = urls.first?.appendingPathComponent("data.plist").path
        return url!
    }
    
    func query() -> [UserLog]{
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
                dataArray.append(log)
                
            }
            return dataArray
        }else {
            sqlError("Query Error", "Failed to retrieve data")
            return []
        }
        
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    //set number of rows to the number of item in testArray
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // configure each individual cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userBp = dataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell") as! BpLogCell

        cell.setUserLog(userBp: userBp )
        
        return cell
    }
    

}
