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
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataTestArray: [UserLog] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTestArray = createTestArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func createTestArray() -> [UserLog] {
        
        
        
        let log1 = UserLog(date: "4/20/19", pulse: "79", systolic: "119", diastolic: "79", notes: "none")
        let log2 = UserLog(date: "4/21/19", pulse: "92", systolic: "130", diastolic: "90", notes: "Forgot Meds")
        let log3 = UserLog(date: "4/22/19", pulse: "80", systolic: "120", diastolic: "80", notes: "none")
        let log4 = UserLog(date: "4/23/19", pulse: "82", systolic: "119", diastolic: "79", notes: "none")
        
        return [log1, log2, log3, log4]
    }

}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    //set number of rows to the number of item in testArray
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTestArray.count
    }
    
    // configure each individual cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userBp = dataTestArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell") as! BpLogCell
        
        cell.setUserLog(userBp: userBp )
        
        return cell
        
        
    }
}
