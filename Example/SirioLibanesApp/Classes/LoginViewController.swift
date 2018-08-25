//
//  LoginViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//
import FirebaseAuth
import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var ingresarButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mailBox: UITextField!
    @IBOutlet weak var passBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
        let userMail = UserDefaults.standard.string(forKey: "lastUserKey")
      mailBox.text = userMail
        mailBox.keyboardType = UIKeyboardType.emailAddress
        mailBox.autocorrectionType = UITextAutocorrectionType.no
        passBox.keyboardType = UIKeyboardType.alphabet
        passBox.isSecureTextEntry = true
        
        ingresarButton.backgroundColor = .clear
        ingresarButton.layer.cornerRadius = 20
        ingresarButton.layer.borderWidth = 1
        ingresarButton.layer.borderColor = UIColor.white.cgColor
      self.navigationItem.backBarButtonItem?.title = ""
      self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func mailStarted(_ sender: Any) {
        bottomConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func mailEnded(_ sender: UITextField) {
        
    }
    @IBAction func mailAction(_ sender: Any) {
        passBox.becomeFirstResponder()
    }
    
    @IBAction func passStarted(_ sender: Any) {
        bottomConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func passAction(_ sender: Any) {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        passBox.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func forgot(_ sender: Any) {
      let email = mailBox.text!;
      
      if (email.isEmpty) {
         displayError(message: "Debes ingresar el mail que quieres recuperar")
         return
      }
      Auth.auth().sendPasswordReset(withEmail: email) { (error) in
         let alert = UIAlertController(title: "¡Mail enviado!", message: "Te hemos enviado un mail de recuperación a tu casilla", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
      }
    }
    
    @IBAction func login(_ sender: Any) {
        let email = mailBox.text!;
        let pass = passBox.text!;
        
      if (email.isEmpty || pass.isEmpty) {
         displayError()
         return
      }
      
      Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
         if (user == nil || error != nil) {
            self.displayError()
            return
         }
         //
         
         let userId = (Auth.auth().currentUser?.uid)!;
         let ref = Database.database().reference()
         ref.child("Users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let userMap = snapshot.value as? [AnyHashable : Any] else {
               return
            }
            
            
            
            let firstName = userMap ["nombre"] as? String?
            let lastName = userMap ["apellido"] as? String?
            let nickname = userMap ["nickname"] as? String?
            
            if (nickname == nil ) {
               self.displayError()
               return
            }
            
            UserDefaults.standard.set(firstName!, forKey: "firstNameKey")
            UserDefaults.standard.set(lastName!, forKey: "lastNameKey")
            UserDefaults.standard.set(nickname!, forKey: "nicknameKey")
            UserDefaults.standard.set(email, forKey: "lastUserKey")
            
            print ("mi user es: " + (user?.displayName ?? "no hay user")  + ", nickname: " + (nickname)!!)
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
            self.displaySuccessfulLogin()
            
         }) { (error) in
            self.displayError()
         }
         
         
         
      }
   }
   
   func displayError (message: String = "Revisa tu mail y contraseña y vuelve a intentarlo") {
      let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
   }
    
    func displaySuccessfulLogin () {
      let alert = UIAlertController(title: "¡Ingreso exitoso!", message: "Ya puedes acceder a todos tus registros en el sistema", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
