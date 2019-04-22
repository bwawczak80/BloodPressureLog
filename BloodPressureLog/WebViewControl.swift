//
//  WebViewControl.swift
//  BloodPressureLog
//
//  Created by Brian Wawczak on 4/22/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit
import WebKit

class WebViewControl: UIViewController {
    @IBOutlet weak var webViewControl: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myUrl = URL(string: "https://www.heart.org/en/health-topics/high-blood-pressure/high-blood-pressure-toolkit-resources")
        
        let request = URLRequest(url: myUrl!)
        
        webViewControl.load(request)
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        //self.performSegue(withIdentifier: "returnFromWebView", sender: self)
        
    }
    
    
    
}

