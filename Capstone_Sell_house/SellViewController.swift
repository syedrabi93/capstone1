//
//  SellViewController.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-03-31.
//

import UIKit
//import FirebaseStorage
//import FirebaseDatabase
import Photos
import Firebase

class SellViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
    

    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var citypicker: UIPickerView!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var size: UITextField!
    @IBOutlet weak var bedroom: UIPickerView!
    @IBOutlet weak var bathroom: UIPickerView!
    @IBOutlet weak var parking: UIPickerView!
    @IBOutlet weak var Age: UIPickerView!
    @IBOutlet weak var availability: UIDatePicker!
    @IBOutlet weak var pincode: UITextField!
    
    
    var delegate : MyPropertiesTableViewController!
    static var isEdit = false
    static var selectedProperty : PropertiesList? = nil
    
    var selectedCity : String = ""
    var selectedBedroom : Int = 1
    var selectedBathroom : Int = 1
    var selectedParking : Int = 1
    var selectedAge : Int = 1
    var dateString: String = ""
    var imageURL: String = ""
    var recordcount : Int = 0
    var name : Any = ""
    var phone : Any = ""
    var imagepickercontroller = UIImagePickerController()
    var propertyID : String = ""
    
    let PropRef = Database.database().reference().child("Properties_data")
    let userRef = Database.database().reference(withPath: "user_data")
    var user = Auth.auth().currentUser!
    
    
    let cityList = ["Toronto" , "Brampton" , "Pickering", "Scarborough" , "Markham" , "Vaughan" , "North York" ,"Richmond Hill" , "Ajax" , "Niagara" ,"Hamilton" , "Burlington" , "Milton"]
    let Counter = [ 1 , 2 , 3 , 4 , 5]
    let ageCounter = [ 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11 , 12 , 13 , 14 , 15 , 16 , 17 , 18 , 19 , 20 , 21 , 22 , 23 , 24 , 25 , 26 , 27 , 28 , 29 , 30]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SellViewController.isEdit == false{
            navigationItem.title = "Add Property"
        }
        else{
            navigationItem.title = "Edit Property"
        }
        availability.addTarget(self, action: #selector(pickAvailability(_:)), for: .valueChanged)
        
        
        citypicker.tag = 1
        bedroom.tag = 2
        bathroom.tag = 3
        parking.tag = 4
        
        
        citypicker.delegate = self
        citypicker.dataSource = self
        self.citypicker.selectRow(0, inComponent: 0, animated: false)
        selectedCity = cityList[0]
        
        bedroom.delegate = self
        bedroom.dataSource = self
        self.bedroom.selectRow(0, inComponent: 0, animated: false)
        selectedBedroom = Counter[0]
        
        bathroom.delegate = self
        bathroom.dataSource = self
        self.bathroom.selectRow(0, inComponent: 0, animated: false)
        selectedBathroom = Counter[0]
        
        
        parking.delegate = self
        parking.dataSource = self
        self.parking.selectRow(0, inComponent: 0, animated: false)
        selectedParking = Counter[0]
        
        Age.delegate = self
        Age.dataSource = self
        self.Age.selectRow(0, inComponent: 0, animated: false)
        selectedParking = Counter[0]
        
        imagepickercontroller.delegate = self
        checkPermissions()
        
        generatePropertyID()
        // Do any additional setup after loading the view.
        
        if (SellViewController.isEdit == true){
            
            print(SellViewController.selectedProperty)
            details.text = SellViewController.selectedProperty?.description
            address.text = SellViewController.selectedProperty?.address
            pincode.text = SellViewController.selectedProperty?.pincode
            price.text = String(SellViewController.selectedProperty!.price)
            size.text = String(SellViewController.selectedProperty!.size)
            
            for  city in cityList
            {
                if (city == SellViewController.selectedProperty?.city){
                    citypicker.selectRow(cityList.firstIndex(of: city)!, inComponent:0, animated:true)
                    selectedCity = cityList[cityList.firstIndex(of: city)!]
                    break
                }
            }
            for  age in ageCounter
            {
                if (age == SellViewController.selectedProperty?.age){
                    Age.selectRow(ageCounter.firstIndex(of: age)!, inComponent:0, animated:true)
                    selectedAge = ageCounter[ageCounter.firstIndex(of: age)!]
                    break
                }
            }
            for  count in Counter
            {
                if (count == SellViewController.selectedProperty?.bedrooms){
                    bedroom.selectRow(Counter.firstIndex(of: count)!, inComponent:0, animated:true)
                    selectedBedroom = Counter[Counter.firstIndex(of: count)!]
                    break
                }
            }
            for  count in Counter
            {
                if (count == SellViewController.selectedProperty?.bathrooms){
                    bathroom.selectRow(Counter.firstIndex(of: count)!, inComponent:0, animated:true)
                    selectedBathroom = Counter[Counter.firstIndex(of: count)!]
                    break
                }
            }
            for  count in Counter
            {
                if (count == SellViewController.selectedProperty?.parking){
                    parking.selectRow(Counter.firstIndex(of: count)!, inComponent:0, animated:true)
                    selectedParking = Counter[Counter.firstIndex(of: count)!]
                    break
                }
                
            }
            let storage = Storage.storage()
            //let data = Data()
            let storageRef = storage.reference()
            let ref = storageRef.child(SellViewController.selectedProperty!.image)
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
                    Picture.contentMode = .scaleAspectFit
                //cell.userImage?.frame.size = CGSize(width: 140, height: 150)
                    Picture.image = image
                }
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "DD-MM-YYYY"
            let date = dateFormatter.date(from: SellViewController.selectedProperty!.availabitity)
            //availability.date = date!
            dateString = SellViewController.selectedProperty!.availabitity
            
           
            
        }
    }

    
    @IBAction func addImage(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func pickAvailability(_ sender: UIDatePicker) {
        print("print \(sender.date)")

            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-YYYY"
            dateString = dateFormatter.string(from: sender.date)

                print(dateString)
        
    }
    

    
  
    
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == citypicker{
            return cityList.count
        }
        else if pickerView == bedroom{
            return Counter.count
        }
        else if pickerView == bathroom{
            return Counter.count
        }
        else if pickerView == parking{
            return Counter.count
        }
        else if pickerView == Age{
            return ageCounter.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == citypicker{
            return cityList[row]
        }
        else if pickerView == bedroom{
            return String(Counter[row])
        }
        else if pickerView == bathroom{
            return String(Counter[row])
        }
        else if pickerView == parking{
            return String(Counter[row])
        }
        else if pickerView == Age{
            return String(ageCounter[row])
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            if pickerView == citypicker{
                selectedCity = cityList[row]
            }
            else if pickerView == bedroom{
                selectedBedroom = Counter[row]
            }
            else if pickerView == bathroom{
                selectedBathroom = Counter[row]
            }
            else if pickerView == parking{
                selectedParking = Counter[row]
            }
            else if pickerView == Age{
                selectedAge = ageCounter[row]
            }
        }
    
    func checkPermissions(){
        if PHPhotoLibrary.authorizationStatus()
            != PHAuthorizationStatus.authorized{
            PHPhotoLibrary.requestAuthorization({ (status : PHAuthorizationStatus) -> Void in
                ()
            })
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
        }else{
            PHPhotoLibrary.requestAuthorization(requestAuthorisationHandler)
        }
        
    }
    
    func requestAuthorisationHandler(status: PHAuthorizationStatus){
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            print("We have access to photos")
        }
        else
        {
            print("We dont have access to photos")
        }
        
    }
        
    func showImagePicker (){
       
        imagepickercontroller.allowsEditing = true;
        imagepickercontroller.sourceType = .photoLibrary
        imagepickercontroller.delegate = self;
        present(imagepickercontroller, animated: true, completion: nil);
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage;
        showimage(image: img);
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            print(url)
            uploadImage(fileURL: url)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func showimage (image: UIImage){
        Picture.image = image;
        Picture.isHidden = false;
        Picture.frame = CGRect(x: 10, y: 10, width: 450, height: 250)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(fileURL : URL){
        let storage = Storage.storage()
        //let data = Data()
        let storageRef = storage.reference()
        
        let localFile = fileURL
        let userid = user.email!.components(separatedBy: "@")
        propertyID = "\(recordcount)\(userid[0])"
        print (propertyID)
        let propertyIdimage = self.propertyID+"image"
        
        let photoRef = storageRef.child(propertyIdimage)
        let uploadTask = photoRef.putFile(from: localFile , metadata: nil){ (metadata , err) in
            guard let metadata = metadata else {
                print(err?.localizedDescription)
                return
            }
            print( "Photo Uploaded ")
            
        }
    }
    
    func generatePropertyID() {
        var records : Int = 0
        self.PropRef.observe(.childAdded, with: { [self] snapshot in
            
            for _ in snapshot.children {
                records += 1
            }
            recordcount = records
        })
        
        
        
        }
    
    
    @IBAction func saveProperty(_ sender: Any) {

        let userid = user.email!.components(separatedBy: "@")
        let path = "\(userid[0])" + "/email"
        print (path)
        
        let addressText = self.address!.text
        let descriptionText = self.details!.text
        let priceText = Int(self.price!.text!)
        let sizeText = Int(self.size!.text!)
        let pincodeText = self.pincode!.text
        let imageName = self.propertyID + "image"

        loadFromFireBase(completionHandler: { message in
             // WHEN you get a callback from the completion handler,
                print(message)
            if (SellViewController.isEdit == false){
            let property = PropertiesList(propertyID: self.propertyID, owner: self.name as! String, price: priceText!, contact:self.phone as! String, city: self.selectedCity, address: addressText!, pincode: pincodeText!, availabitity: self.dateString, bedrooms: self.selectedBedroom, bathrooms: self.selectedBathroom, parking: self.selectedParking , age: self.selectedAge, size: sizeText!, description: descriptionText!, image: imageName )
            
            let propertyRef = self.PropRef.child((self.propertyID.lowercased()))
            propertyRef.setValue(property.toAnyObject())
            self.navigationController?.popViewController(animated: true)

            }
        if (SellViewController.isEdit == true){
            print(SellViewController.selectedProperty!.propertyID)
            
            let property = PropertiesList(propertyID: SellViewController.selectedProperty!.propertyID, owner: self.name as! String, price: priceText!, contact:self.phone as! String, city: self.selectedCity, address: addressText!, pincode: pincodeText!, availabitity: self.dateString, bedrooms: self.selectedBedroom, bathrooms: self.selectedBathroom, parking: self.selectedParking , age: self.selectedAge, size: sizeText!, description: descriptionText!, image: SellViewController.selectedProperty!.image )
            
            print(SellViewController.selectedProperty!.propertyID)
            let propertyRef = self.PropRef.child((SellViewController.selectedProperty!.propertyID.lowercased()))
            propertyRef.setValue(property.toAnyObject())
            self.navigationController?.popViewController(animated: true)
        }
        })
        
        }
   
        
    func loadFromFireBase(completionHandler:@escaping (_ message: String) -> Void) {
    
        let query = self.userRef.queryOrdered(byChild: "email").queryEqual(toValue: user.email!)
    query.observeSingleEvent(of: .value, with: { [self] (snapshot) in
        print ("I am here")
        print(snapshot)
            guard snapshot.exists() != false else { return }
        for child in snapshot.children {
            let recipeSnap = child as! DataSnapshot
            let dict = recipeSnap.value as! [String:AnyObject]
             name = dict["name"] as! String
             phone = dict["mobile"] as! String
                
                print (name)
            
        }
        completionHandler("DONE")
    })
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
