//
//  ViewController.swift
//  LXKDateSwitch
//
//  Created by 李现科 on 16/5/13.
//  Copyright © 2016年 李现科. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var yearToAddTF: UITextField!
    @IBOutlet weak var monthToAddTF: UITextField!
    @IBOutlet weak var dayToAddTF: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func caculate(sender: AnyObject) {
        if let date = LXKDateSwitch.transformToDate(dateFormat: "yyyy-MM-dd")(fromString: dateTF.text ?? "") {
            let addedDate1 = LXKDateSwitch.sharedInstance.addDays(Int(dayToAddTF.text ?? "") ?? 0, toDate: date)
            let addedDate2 = LXKDateSwitch.sharedInstance.addMonths(Int(monthToAddTF.text ?? "") ?? 0, toDate: addedDate1)
            let addedDate3 = LXKDateSwitch.sharedInstance.addMonths(0, toDate: addedDate2)
            outputLabel.text = LXKDateSwitch.transformToString(dateFormat: "yyyy-MM-dd")(fromDate: addedDate3)
        } else {
            outputLabel.text = "date format must be yyyy-MM-dd"
        }
    }

}

