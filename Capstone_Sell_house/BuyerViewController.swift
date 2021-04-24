//
//  BuyerViewController.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-03-29.
//

import UIKit
import MapKit
import Firebase
import Photos
import CoreLocation



class BuyerViewController: UIViewController, MKMapViewDelegate,UITableViewDelegate, UITableViewDataSource,wishlist  {
    var searchResults : [PropertiesList] = []
    let Propref = Database.database().reference().child("Properties_data")
    let wishList = Database.database().reference().child("WishList_Properties")
    let userRef = Database.database().reference(withPath: "user_data")
    let user = Auth.auth().currentUser!
    var currentProperties: [String] = []
    var locList : [LocationList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.becomeFirstResponder()

        // Do any additional setup after loading the view.
        
        var cellNib = UINib(nibName:
              TableViewCellIdentifiers.searchResultCell, bundle: nil)
          tableView.register(cellNib, forCellReuseIdentifier:TableViewCellIdentifiers.searchResultCell)
                                  
        cellNib = UINib(nibName:
          TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
          TableViewCellIdentifiers.nothingFoundCell)
        
        
        
//        Propref.observe(.value, with: { snap in
//          guard let email = snap.value as? String else { return }
//          self.currentProperties.append(email)
//          let row = self.currentProperties.count - 1
//          let indexPath = IndexPath(row: row, section: 0)
//          self.tableView.insertRows(at: [indexPath], with: .top)
//        })
//        
//        Propref.observe(.childRemoved, with: { snap in
//          guard let emailToFind = snap.value as? String else { return }
//          for (index, email) in self.currentProperties.enumerated() {
//            if email == emailToFind {
//              let indexPath = IndexPath(row: index, section: 0)
//              self.currentProperties.remove(at: index)
//              self.tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//          }
//        })
        self.definesPresentationContext = true;
        
        searchBar.delegate = self
        //searchBar.showsSearchResultsButton = self
        
        mapView.delegate = self;
        mapView.isHidden = true
        tableView.isHidden = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 150
        fetchdata("" , completionHandler: { message in
                    print(message)})
        getCoordinates()
        showUser()
        

    }
    
    
    
    @IBOutlet weak var viewType: UISegmentedControl!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    @IBAction func onSegmentChangw(_ sender: UISegmentedControl) {
     switch sender.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false;
            mapView.isHidden = true
        case 1:
            tableView.isHidden = true;
            mapView.isHidden = false
        default:
            print("DefaultCase")
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count == 0 {
           return 1
       } else {
           return searchResults.count
         }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchResults.count == 0 {
          return tableView.dequeueReusableCell(withIdentifier:
            TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
          let cell = tableView.dequeueReusableCell(withIdentifier:
            TableViewCellIdentifiers.searchResultCell,
            for: indexPath) as! WithResults
            let searchResult = searchResults[indexPath.row]
            

            cell.City.text = searchResult.city
            cell.Price.text = String(searchResult.price)
            cell.Bedroom.text = String(searchResult.bedrooms)
            cell.Bathroom.text =  String(searchResult.bathrooms)
            cell.Availability.text = searchResult.availabitity
            cell.Parking.text = String(searchResult.parking)
            cell.size.text = String(searchResult.size)
            
            
            cell.delegate = self
            
            cell.wishlist.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
           
           
            
            let storage = Storage.storage()
            //let data = Data()
            let storageRef = storage.reference()
            let ref = storageRef.child(searchResult.image)
            ref.downloadURL { (url, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                        let imageURL = url!
                DispatchQueue.main.async
                {
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                    
                cell.userImage?.contentMode = .scaleAspectFit
                //cell.userImage?.frame.size = CGSize(width: 140, height: 150)
                cell.userImage!.image = image
                cell.userImage!.translatesAutoresizingMaskIntoConstraints = false
                cell.userImage?.layer.cornerRadius = (cell.imageView?.frame.width)! / 2
                cell.userImage?.layer.masksToBounds = true
                    //self.tableView.reloadData()
                    
                    
                }
               
                
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell
        }
            
    }
    
    func tableView(_ tableView: UITableView,
         didSelectRowAt indexPath: IndexPath) {
        let selectedRow = self.searchResults[indexPath.row];
//        AddTableViewController.isEdit = true
        DetailsViewController.selectedProperty = selectedRow
        performSegue(withIdentifier: "viewDetails", sender: nil)
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView,
         willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      if searchResults.count == 0 {
        return nil
    } else {
        return indexPath
      }
    }
    
    func fetchdata (_ query : String,completionHandler:@escaping (_ message: String) -> Void){
        do{
            self.Propref.observe(.value, with: { (snapshot: DataSnapshot) in
                //var newItems: [PropertiesList] = []
                for child in snapshot.children.allObjects  {
                    
                    if let snapshot = child as? DataSnapshot,

                       let property = PropertiesList(snapshot: snapshot) {
                            if (query == "")
                            {
                                self.searchResults.append(property)
                                print (property)
                            }
                            else{
                                let dict = snapshot.value as! [String: Any]
                                let city = dict["city"] as! String
                                if (city == query)
                                {
                                    self.searchResults.append(property)
                                }
                            }
                    }

                }
                self.tableView.reloadData()
                self.getCoordinates()
                completionHandler(self.searchResults[0].address)
            })
            
        }
    }
    

    
    func showUser(){
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.5789 ,longitude: -79.6583), latitudinalMeters: 50000, longitudinalMeters: 60000)
        self.mapView.setRegion(region, animated: true);
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        self.mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    
    
    
    func getCoordinates(){
        
        for properties in searchResults
        {
            
            let address = properties.pincode
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address, completionHandler: { [self](placemarks, error) -> Void in
                if (placemarks!.count > 0) {
                        let topResult: CLPlacemark = (placemarks?[0])!
                        let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                        var region: MKCoordinateRegion = self.mapView.region

                        region.center.latitude = (placemark.location?.coordinate.latitude)!
                        region.center.longitude = (placemark.location?.coordinate.longitude)!

                        //region.span = MKCoordinateSpanMake(0.5, 0.5)
                        //placemark.title = String(properties.price)
                        //placemark.subtitle = properties.address
                    let location = LocationList(title: properties.pincode, lat: (placemark.location?.coordinate.latitude)!, long: (placemark.location?.coordinate.longitude)!)

                        locList.append(location)
                        self.mapView.setRegion(region, animated: true)
                        self.mapView.addAnnotation(placemark)
                    }
                })
        }
                // Use your location
        }
    
    @IBAction func backbutton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
//        guard  annotation is searchResults else {
//            print("Mapview not working")
//            return nil;
//       }
        
        let identifier = "PropertiesList"
        
        var annotationlist = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationlist == nil {
            let pinView = MKPinAnnotationView(annotation: annotation,reuseIdentifier: identifier)
              pinView.isEnabled = true
              pinView.canShowCallout = true
              pinView.animatesDrop = false
              pinView.pinTintColor = UIColor(red: 0.32, green: 0.82,
                                            blue: 0.4, alpha: 1)
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self,
                              action: #selector(showLocationDetails),
                                 for: .touchUpInside)
              pinView.rightCalloutAccessoryView = rightButton
            annotationlist = pinView
            }
        
            if let annotationView = annotationlist {
              annotationView.annotation = annotation
                
              let button = annotationView.rightCalloutAccessoryView
                           as! UIButton
                
                
                var counter : Int = 0
                for loc in locList {
                    if annotationView.annotation?.title == loc.title{
                        button.tag = counter
                    }
                    else{
                        counter += 1
                    }
                    
                }
   
                }
                

              return annotationlist
            
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is DetailsViewController){
            let contolerr = (segue.destination as! DetailsViewController)
            contolerr.delegate = self;
        }
        switch segue.identifier ?? "" {
        case "viewDetails":
            
            if(tableView.isHidden){
                let buttn = sender as! UIButton;
                DetailsViewController.selectedProperty = searchResults[buttn.tag];
            }
            
            break;
            
            
        default:
            print(segue.identifier!)
        }
        
        
    }
    
    
    @objc func showLocationDetails (_ sender: UIButton){
       
        performSegue(withIdentifier: "viewDetails", sender: sender)
    }
    
    func clearSearchData(){
        searchResults.removeAll()
            
        }
    
    
    func wishListSelection(sender: WithResults) {
        
        if let selectedRow = tableView.indexPath(for: sender){
            let wishlistedPropertry = searchResults[selectedRow.row]
            if( sender.wishlist.isSelected != true ){
                let userid = user.email!.components(separatedBy: "@")
                
                let property = WishList(propertyID: wishlistedPropertry.propertyID, owner: wishlistedPropertry.owner, price: wishlistedPropertry.price, contact: wishlistedPropertry.contact, city: wishlistedPropertry.city, address: wishlistedPropertry.address, pincode: wishlistedPropertry.pincode, availabitity: wishlistedPropertry.availabitity, bedrooms: wishlistedPropertry.bedrooms, bathrooms: wishlistedPropertry.bathrooms, parking: wishlistedPropertry.parking, age: wishlistedPropertry.age, size: wishlistedPropertry.size, description: wishlistedPropertry.description, addedby: userid[0], image: wishlistedPropertry.image)
                
                let propertyRef = self.wishList.child((wishlistedPropertry.propertyID.lowercased()))
                propertyRef.setValue(property.toAnyObject())
            }
            else if (sender.wishlist.isSelected != false){
                let ref = wishList.child(wishlistedPropertry.propertyID)
                wishList.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild(wishlistedPropertry.propertyID){
                        ref.removeValue()
                    }
                })
            }
        }
        
    }
    
    @objc func didButtonClick(sender : UIButton){
        if (sender.isSelected == true )
        {
            sender.isSelected = false
            self.tableView.reloadData()
        }
        else if (sender.isSelected == false )
        {
            sender.isSelected = true
            self.tableView.reloadData()
        }
        
    }
    
    
    
}

struct TableViewCellIdentifiers {
    static let searchResultCell = "withResult"
    static let nothingFoundCell = "withoutResult"
}

extension BuyerViewController: UISearchBarDelegate {
    
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //if !searchBar.text!.isEmpty {
    if let txt = searchBar.text {
    searchBar.resignFirstResponder()
        //hasSearched = true
        clearSearchData()
        fetchdata(txt , completionHandler: { message in
                    print(message)})
        //searchResults = []
        tableView.reloadData()
      }
   
}
    //on cancel search button click
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        clearSearchData()
        fetchdata("", completionHandler: { message in
                    print(message)})
        //deleteAllData()
        tableView.reloadData()
    }
}

struct LocationList{
    var title: String
    var lat: Double
    var long: Double
}
