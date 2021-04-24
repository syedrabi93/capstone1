//
//  ViewController.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-03-24.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    let loginToList = "LoginToList"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.wantsFullScreenLayout = true;
//        Auth.auth().addStateDidChangeListener() { auth, user in
//          if user != nil {
//            self.performSegue(withIdentifier: self.loginToList, sender: nil)
//            self.email.text = nil
//            self.password.text = nil
//          }
//        }
      
    }

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    
    
    @IBAction func loginButton(_ sender: Any) {
        guard
        let inputEmail = email.text,
        let inputPassword = password.text,
        
        inputEmail.count > 0,
        inputPassword.count > 0
        else {
          return
      }
        
        Auth.auth().signIn(withEmail: inputEmail, password: inputPassword) { user, error in
          if let error = error, user == nil {
            let alert = UIAlertController(title: "Sign In Failed",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
          }
            else if user != nil {
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
                self.email.text = nil
                self.password.text = nil
              }
        }
        
    }
    @IBAction func signupButton(_ sender: Any) {
//        let alert = UIAlertController(title: "Register",
//                                      message: "Register",
//                                      preferredStyle: .alert)
//
//        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
//
//          let emailField = alert.textFields![0]
//          let passwordField = alert.textFields![1]
//
//          Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
//            if error == nil {
//              Auth.auth().signIn(withEmail: self.email.text!,
//                                 password: self.password.text!)
                //self.performSegue(withIdentifier: "addProfile", sender: nil)
//                self.email.text = nil
//                self.password.text = nil
//            }
//          }
//       
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .cancel)
//
//        alert.addTextField { textEmail in
//          textEmail.placeholder = "Enter your email"
//        }
//
//        alert.addTextField { textPassword in
//          textPassword.isSecureTextEntry = true
//          textPassword.placeholder = "Enter your password"
//        }
//
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true, completion: nil)
        
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is ProfileViewController){
            let contoller = (segue.destination as! ProfileViewController)
            contoller.delegate = self;
        }
        switch segue.identifier ?? "" {
        case "addProfile":
            ProfileViewController.isEdit = false;
            break;
        default:
            print(segue.identifier!)
        }
        
        
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        let alert = UIAlertController(title: "Forget Password ?? " ,
                                              message: "Reset your Password here",
                                              preferredStyle: .alert)
        
                let saveAction = UIAlertAction(title: "Reset", style: .default) { _ in
        
                  let emailField = alert.textFields![0]
        
                    Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
                        DispatchQueue.main.async {

                            if let error = error {
                                print(error.localizedDescription)
                            }
                            else {
                                let alertmessage = UIAlertController(title: "Reset Password" ,
                                                                      message: "Password reset instructions has been mailed to the given mail id",
                                                                      preferredStyle: .alert)
                                

                                let cancelAction = UIAlertAction(title: "Ok",style: .default)
                                alertmessage.addAction(cancelAction)
                                self.present(alertmessage, animated: true, completion: nil)
                                
                                
                            }
                        }
                    }
                    
        
                }
        
        alert.addTextField { textEmail in
                  textEmail.placeholder = "Enter your email"
        }
        
                alert.addAction(saveAction)
        
                present(alert, animated: true, completion: nil)
    }
    
}

