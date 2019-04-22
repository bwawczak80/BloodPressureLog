//
//  RecsViewController.swift
//  BloodPressureLog
//
//  Created by Brian Wawczak on 4/4/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit
import WebKit

class RecsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    

    @IBAction func onClick(_ sender: Any) {
//        UIApplication.shared.open(URL(string: "https://www.heart.org/en/health-topics/high-blood-pressure/high-blood-pressure-toolkit-resources")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func backFromModal(_ segue: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 3
    }
    

}
