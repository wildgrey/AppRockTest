//
//  Tutorial1ViewController.swift
//  AppRockTest
//
//  Created by Sergey Vishnyov on 12/4/18.
//  Copyright © 2018 Sergey Vishnyov. All rights reserved.
//

import UIKit

class Tutorial1ViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        nextButton.isEnabled = AppRockManager.sharedInstance.isLoactionEnabled()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateUI(notification:)),
                                               name: Notification.Name("didChangeAuthorizationWhenInUse"),
                                               object: nil)
    }
    
    // MARK: - Actions
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "Tutorial2ViewController") as! Tutorial2ViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func updateUI(notification: Notification) {
        nextButton.isEnabled = true
    }
}

