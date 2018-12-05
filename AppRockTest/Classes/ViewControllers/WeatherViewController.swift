//
//  WeatherViewController.swift
//  AppRockTest
//
//  Created by Sergey Vishnyov on 12/4/18.
//  Copyright © 2018 Sergey Vishnyov. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if AppRockManager.sharedInstance.isDataLoaded(nil) {
            descriptionLabel.text = "\(AppRockManager.sharedInstance.currentTemperature!)˚C in \(AppRockManager.sharedInstance.currentCity!)"
        } else {
            AppRockManager.sharedInstance.showLoadingViewController()
        }
    }

}
