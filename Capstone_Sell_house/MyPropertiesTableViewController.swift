//
//  MyPropertiesTableViewController.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-04-08.
//

import UIKit
import Firebase

class MyPropertiesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var cellNib = UINib(nibName:
//              TableViewCellIdentifiers.searchResultCell, bundle: nil)
//          tableView.register(cellNib, forCellReuseIdentifier:TableViewCellIdentifiers.searchResultCell)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = 150
        tableView.dataSource = self;
        tableView.delegate = self;
        if (MyPropertiesTableViewController.isWishList == false){
        navigationItem.title = "Properties List"
        }
        else{
            navigationItem.title = "My WishList"
        }
        loadFromFireBase(completionHandler: { message in
            print (message)
        })
        self.tableView.reloadData()
    }
  
    // MARK: - Table view data source

    static var isWishList = false
    var propList : [PropertiesList] = []
    var wishListProp : [WishList] = []
    let Propref = Database.database().reference().child("Properties_data")
    let userRef = Database.database().reference(withPath: "user_data")
    let wishList = Database.database().reference().child("WishList_Properties")
    let user = Auth.auth().currentUser!

    
    
    func loadFromFireBase(completionHandler:@escaping (_ message: String) -> Void) {
        
        
        let userid = user.email!.components(separatedBy: "@")
        if (MyPropertiesTableViewController.isWishList == false){
            let query = self.Propref.queryOrdered(byChild: "propertyID").queryEnding(beforeValue: userid[0])
            query.observeSingleEvent(of: .value, with: { [self] (snapshot) in
                print ("I am here")
                print(snapshot)
                guard snapshot.exists() != false else { return }
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let property = PropertiesList(snapshot: snapshot) {
                        if property.propertyID.contains(userid[0]){
                            self.propList.append(property)
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
        else if(MyPropertiesTableViewController.isWishList == true){
            let query = self.wishList.queryOrdered(byChild: "addedby").queryEqual(toValue: userid[0])
            query.observeSingleEvent(of: .value, with: { [self] (snapshot) in
                print ("I am here")
                print(snapshot)
                guard snapshot.exists() != false else { return }
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let property = WishList(snapshot: snapshot) {
                        self.wishListProp.append(property)
                    }
                }
                self.tableView.reloadData()
            })
        }
        
        completionHandler("DONE")
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(MyPropertiesTableViewController.isWishList == true){
            return wishListProp.count
        }
        else{
            return propList.count
        }
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"withResult") as! propertiesCell
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        if(MyPropertiesTableViewController.isWishList == true){
            let property = wishListProp[indexPath.row]
            let ref = storageRef.child(property.image)
            ref.downloadURL { (url, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                //DispatchQueue.main.async
                //{
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)

                    cell.initialize(price: String(property.price), city: String(property.city), availability: String(property.availabitity), size: String(property.size), parking: String(property.parking), bedrooms: String(property.bedrooms), bathrooms: String(property.bathrooms), propImage: image!)
                
                    
                }
        }
        else{
            
            let property = propList[indexPath.row]
            let ref = storageRef.child(property.image)
            ref.downloadURL { (url, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                //DispatchQueue.main.async
                //{
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)

                    cell.initialize(price: String(property.price), city: String(property.city), availability: String(property.availabitity), size: String(property.size), parking: String(property.parking), bedrooms: String(property.bedrooms), bathrooms: String(property.bathrooms), propImage: image!)
                
                    
                }
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        //self.tableView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView,
         didSelectRowAt indexPath: IndexPath) {
        if(MyPropertiesTableViewController.isWishList == false){
            let selectedRow = self.propList[indexPath.row];
            SellViewController.selectedProperty = selectedRow
            SellViewController.isEdit = true
            //performSegue(withIdentifier: "editProperties", sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else{
            let selectedRow = self.wishListProp[indexPath.row];
            DetailsViewController.wishListProperty = selectedRow
            //performSegue(withIdentifier: "viewWishList", sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "editProperties" {
                SellViewController.isEdit = true;
                let cont = (segue.destination as! SellViewController)
        
        }
        else if segue.identifier == "viewWishList"{
            let cont = (segue.destination as! DetailsViewController)
        }
        
        
    }
    
}
