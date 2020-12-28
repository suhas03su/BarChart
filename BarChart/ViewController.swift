//
//  ViewController.swift
//  BarChart
//
//  Created by Suhas on 18/09/19.
//  Copyright © 2019 Suhas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var newVariableToCheck: String = ""
    @IBOutlet weak var chartView: MacawChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
    }

    @IBAction func loadBarGraph(_ sender: Any) {
        MacawChartView.playAnimations()
    }
    
}

