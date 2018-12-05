//
//  Tutorial2ViewController.swift
//  AppRockTest
//
//  Created by Sergey Vishnyov on 12/4/18.
//  Copyright © 2018 Sergey Vishnyov. All rights reserved.
//

import UIKit

class Tutorial2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

// MARK: - Actions
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        let navigationViewController = UINavigationController.init(rootViewController: viewController)
        navigationViewController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navigationViewController
    }
}
