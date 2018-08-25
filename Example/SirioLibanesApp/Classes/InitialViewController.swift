//
//  InitialViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var ingresarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ingresarButton.backgroundColor = .clear
        
        registerButton.backgroundColor = .clear
        registerButton.layer.cornerRadius = 20
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        self.navigationItem.backBarButtonItem?.title = " "
      self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.setHidesBackButton(true, animated:false);
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        if (self.navigationController?.viewControllers.count == 1) {
        self.view.window?.backgroundColor = UIColor.white
        self.navigationController?.view.alpha = 0;
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.viewControllers.count == 1) {
            if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "autoLogin", sender: self)
            }
            self.navigationController?.view.alpha = 1;
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
