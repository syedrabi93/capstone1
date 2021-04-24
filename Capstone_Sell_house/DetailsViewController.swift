//
//  DetailsViewController.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-04-07.
//

import UIKit
import Firebase

class DetailsViewController: UIViewController {

    static var selectedProperty : PropertiesList? = nil
    static var wishListProperty : WishList? = nil
    var delegate : BuyerViewController!
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var bedrooms: UILabel!
    @IBOutlet weak var bathrooms: UILabel!
    @IBOutlet weak var parking: UILabel!
    @IBOutlet weak var pincode: UILabel!
    @IBOutlet weak var details: UITextView!
    
    
    @IBAction func chatnow(_ sender: Any) {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func okButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Property Details"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        if DetailsViewController.wishListProperty == nil {
            owner.text = DetailsViewController.selectedProperty?.owner
            contact.text = DetailsViewController.selectedProperty?.contact
            price.text = "\(String((DetailsViewController.selectedProperty?.price)!)) K$"
            size.text = "\(String((DetailsViewController.selectedProperty?.size)!)) sqft"
            city.text = DetailsViewController.selectedProperty?.city
            availability.text = DetailsViewController.selectedProperty?.availabitity
            address.text = DetailsViewController.selectedProperty?.address
            details.text = DetailsViewController.selectedProperty?.description
            parking.text = "\(String((DetailsViewController.selectedProperty?.parking)!)) slots"
            bedrooms.text = "\(String((DetailsViewController.selectedProperty?.bedrooms)!)) bedrooms"
            bathrooms.text = "\(String((DetailsViewController.selectedProperty?.bathrooms)!)) bathrooms"
            pincode.text = DetailsViewController.selectedProperty?.pincode
            let ref = storageRef.child(DetailsViewController.selectedProperty!.image)
            ref.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
                    let imageURL = url!
            DispatchQueue.main.async
            { [self] in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            
                detailImage.image = image
                //self.tableView.reloadData()
            }
           
            
        }
        }
        else{
            owner.text = DetailsViewController.wishListProperty?.owner
            contact.text = DetailsViewController.wishListProperty?.contact
            price.text = "\(String((DetailsViewController.wishListProperty?.price)!))$"
            size.text = "\(String((DetailsViewController.wishListProperty?.size)!)) sqft"
            city.text = DetailsViewController.wishListProperty?.city
            availability.text = DetailsViewController.wishListProperty?.availabitity
            address.text = DetailsViewController.wishListProperty?.address
            details.text = DetailsViewController.wishListProperty?.description
            parking.text = "\(String((DetailsViewController.wishListProperty?.parking)!)) slots"
            bedrooms.text = "\(String((DetailsViewController.wishListProperty?.bedrooms)!)) bedrooms"
            bathrooms.text = "\(String((DetailsViewController.wishListProperty?.bathrooms)!)) bathrooms"
            pincode.text = DetailsViewController.wishListProperty?.pincode
            let ref = storageRef.child(DetailsViewController.wishListProperty!.image)
            ref.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
                    let imageURL = url!
            DispatchQueue.main.async
            { [self] in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            
                detailImage.image = image
                //self.tableView.reloadData()
            }
           
            
        }
        }
        

        
        // Do any additional setup after loading the view.
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
