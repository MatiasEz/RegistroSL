//
//  HomeViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PKHUD
import AVFoundation

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyState: UIView!
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    var ref: DatabaseReference!
    var userItemList : [[String : Any] ] = []
    var firstTime : Bool = true
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var underline: UIView!
    var userId : String? = nil
    
    override func viewDidLoad() {
        
        ref = Database.database().reference()
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationItem.setHidesBackButton(true, animated:false);
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emptyState.alpha = 0;
        self.tableView.alpha = 0;
        self.tableView.delegate = self;
      self.tableView.backgroundColor = UIColor.black;
        self.tableView.dataSource = self;
      self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        if (backViewController() is RegisterViewController && firstTime) {
            updateViewWithCurrentInformation()
            firstTime = false;
            return
        }
        
        self.tableView.backgroundColor = UIColor.clear
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        getUserDataAndContinue()
    }
    
    func backViewController () -> UIViewController?
    {
        let numberOfViewControllers = self.navigationController?.viewControllers.count ?? 0;
        if (numberOfViewControllers < 2) {
            return nil;
        } else {
            return self.navigationController?.viewControllers [numberOfViewControllers - 2];
        }
    }
    
    func getUserDataAndContinue () {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.displayError(message: "Hubo un problema con tu usuario, por favor deslogueate y vuelve a empezar")
            return;
        }
  
        
        ref.child("List").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userEventData = snapshot.value as? [String : [String : Any]]
            if let unwEventData = userEventData {
                print (unwEventData.description)
               self.userItemList = []
               for (_, map) in unwEventData {
                  self.userItemList.append(map)
               }
               
               self.userItemList = self.userItemList.sorted(by: self.sorterForMap)
               
               
               
               self.updateViewWithCurrentInformation()
            } else {
                self.updateViewWithCurrentInformation()
            }
        }) { (error) in
            self.displayError(message: "Hubo un problema obteniendo los eventos, por favor deslogueate y vuelve a empezar")
            return
        }
    }
    
    func updateViewWithCurrentInformation () {
        
        self.tableView.alpha = 0;
        self.emptyState.alpha = 0;
        self.underline.alpha = 0;
        self.titleLabel.alpha = 0;
        self.tableView.tableFooterView = nil

        let visibleView = (self.userItemList.count > 0) ? self.tableView as UIView : self.emptyState as UIView
        UIView.animate(withDuration: 0.3, animations: {
            visibleView.alpha = 1
        })
        
        
        if (self.userItemList.count > 0) {
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
            self.underline.alpha = 1
            self.titleLabel.alpha = 1
        }
      
        PKHUD.sharedHUD.hide(afterDelay: 0.3) { success in
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userItemList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let map = self.userItemList [indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
        cell.tag = indexPath.row
        cell.asociatedDictionary = map
      let displayName = map ["display_name"] as! String?
        cell.titlecustomLabel.text = displayName
      
      let state = map ["state"] as! String?
      if (state == "Activo") {
         cell.colorbox.backgroundColor = UIColor.green
      }
      
      if (state == "Inactivo") {
         cell.colorbox.backgroundColor = UIColor.red
      }
      
      let date = Date(timeIntervalSince1970: TimeInterval(map ["timestamp"] as! Int))
      let dayTimePeriodFormatter = DateFormatter()
      dayTimePeriodFormatter.dateFormat = "HH:mm dd-MM-yy"
      
      let dateString = dayTimePeriodFormatter.string(from: date)
      cell.dateLabel.text = dateString as! String?
      cell.colorbox.layer.cornerRadius = 15
      return cell
    }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      let map = self.userItemList [indexPath.row]
      self.userId = map ["user_id"] as! String?
      
      self.performSegue(withIdentifier: "detail", sender: self)
   }
    @IBAction func update(_ sender: Any) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        self.getUserDataAndContinue()
    }
    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Cerrar sesión", message: "¿Está seguro de que desea cerrar su sesión?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sí", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            self.performSegue(withIdentifier: "logout", sender: self)
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
      
        self.present(alert, animated: true, completion: nil)
    }
   
   func sorterForMap(this:[String:Any], that:[String:Any]) -> Bool {
      let monto1 = this ["display_name"] as! String
      let monto2 = that ["display_name"] as! String
      if (monto1 > monto2) {
        return false
      } else {
         return true;
      }
   }
    
    func displayError (message: String = "No pudimos obtener tus eventos, intenta mas tarde.") {
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        PKHUD.sharedHUD.hide(afterDelay: 0.3) { success in
            // Completion Handler
        }
    }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let vc = segue.destination as? DetailViewController {
         vc.userId = self.userId!
      }
   }
   
}
