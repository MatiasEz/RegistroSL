//
//  PermissionViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 27/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class PermissionViewController: UIViewController {
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var manualAccessButton: UIButton!
    
    override func viewDidLoad() {
      self.setUpView()
      super.viewDidLoad()
    }
   
   func setUpView () {
      self.activateButton.backgroundColor = .clear
      self.activateButton.layer.cornerRadius = 20
      self.activateButton.layer.borderWidth = 1
      self.activateButton.layer.borderColor = UIColor.white.cgColor
      
      self.manualAccessButton.backgroundColor = .clear
      self.manualAccessButton.layer.cornerRadius = 20
      self.manualAccessButton.layer.borderWidth = 1
      self.manualAccessButton.layer.borderColor = UIColor.white.cgColor
   }

    @IBAction func goToSettings(_ sender: Any) {
      UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
    }
    
    
    @IBAction func goToScanner(_ sender: Any) {
        self.performSegue(withIdentifier: "newEvent", sender: nil)
    }
}
