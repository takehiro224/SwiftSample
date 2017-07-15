//
//  TestTargetViewController.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/06/12.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit

class TestTargetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isNumber(numStr: String) -> Bool {
        if Int(numStr) != nil {
            return true
        } else {
            return false
        }
    }

}
