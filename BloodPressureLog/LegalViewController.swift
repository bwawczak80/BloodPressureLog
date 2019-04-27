//
//  LegalViewController.swift
//  BloodPressureLog
//
//  Created by Brian Wawczak on 4/12/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit
import WebKit

class LegalViewController: UIViewController {
    
    
    @IBOutlet weak var disclaimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let disclaimerStatement = "The information contained in the Blood Pressure Log mobile app (\"The Service\" is for general information purposes only.  Brian Wawczak (\"The Creator\" assumes no responsibility for error or omissions in the contents of the Service. In no event shall the creator be liable for any special, direct, indirect, consequential, or incidental damages or any damages whatsoever, whether in an action of contract, negligence or other sort, arising out of or in connection with the use of the Service or the contents of the Service.  This app should not be used for the diagnoses or treatment of any medical condition.  All medical decisions and or treatment should be thoroughly discussed with a doctor.  The creator reserves the right to make additions, deletions, or modifications to the contents of the Service at any time without prior notice.  This Disclaimer has been created with the help of TermsFeed Disclaimer Generator.\n\nExternal links disclaimer\nThe Service contains links to external websites that are not provided or maintained by or in any way affiliated with the creator.  Please note that the creator does not guarantee the accuracy, relevance, timeliness, or completeness of any information on these external websites."
        
        disclaimer.text = disclaimerStatement
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func enter(_ sender: Any) {
        
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
