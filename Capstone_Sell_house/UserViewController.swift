//
//  UserViewController.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-03-29.
//

import UIKit
import Firebase

class UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
      if segue.identifier == "editProfile" {
        let controller = segue.destination as!
                         ProfileViewController
        ProfileViewController.isEdit = true
        
      }
        if segue.identifier == "myWishList" {
            let controller = segue.destination as!
                             MyPropertiesTableViewController
            MyPropertiesTableViewController.isWishList = true
        }
        if segue.identifier == "myProperties" {
            let controller = segue.destination as!
                             MyPropertiesTableViewController
            MyPropertiesTableViewController.isWishList = false
        }
        if segue.identifier == "sell" {
            let controller = segue.destination as!
                SellViewController
            SellViewController.isEdit = false
        }
    }
    
    @IBAction func Messages(_ sender: UIButton) {
//        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(chatLogController, animated: true)
        
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
          } catch (let error) {
            print("Auth sign out failed: \(error)")
          }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        
        let ref = Database.database().reference().child("Messages")
        
        ref.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
                print("message")
                
                //this will crash because of background thread, so lets call this on dispatch_async main thread
            }
            
            }, withCancel: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
