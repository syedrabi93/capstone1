//
//  ProfileViewController.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-03-27.
//

import UIKit
import Firebase
//import FirebaseDatabase


class ProfileViewController: UITableViewController ,UIPickerViewDelegate, UIPickerViewDataSource{
  
    

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var dob: UIDatePicker!
    
    @IBOutlet weak var gender: UIPickerView!
    
    @IBOutlet weak var country: UILabel!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var mobile: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    let userRef = Database.database().reference(withPath: "user_data")
    var delegate : LoginViewController!
    static var isEdit: Bool = false;
    
    var CountryName = "None"

    var genderData: [String] = [String]()
    var selectedGender: String = ""
    
    var somedateString: String = ""
    var nameText: String = ""
    var phoneText: String = ""
    
    static let UserRef = Database.database().reference(withPath: "user_data")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Setup Profile"
        dob.addTarget(self, action: #selector(pickDate(_:)), for: .valueChanged)
        
        genderData = ["Male","Female"]
        
        self.gender.delegate = self
        self.gender.dataSource = self
        self.gender.selectRow(0, inComponent: 0, animated: false)
        selectedGender = genderData[0]
        
        country.text = CountryName

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if (ProfileViewController.isEdit == true){
            loadFromFireBase(completionHandler: { message in
                print (message)
                
            })
            
        }
    }

    // MARK: - Table view data source
    func loadFromFireBase(completionHandler:@escaping (_ message: String) -> Void) {
        var user = Auth.auth().currentUser!
        let query = self.userRef.queryOrdered(byChild: "email").queryEqual(toValue: user.email!)
    query.observeSingleEvent(of: .value, with: { [self] (snapshot) in
        print ("I am here")
        print(snapshot)
            guard snapshot.exists() != false else { return }
        for child in snapshot.children {
            let recipeSnap = child as! DataSnapshot
            let dict = recipeSnap.value as! [String:AnyObject]
            name.text = dict["name"] as! String
            mobile.text = dict["mobile"] as! String
            selectedGender = dict["gender"] as! String
             somedateString = dict["dob"] as! String
            country.text = dict["country"] as! String
             //dob.value(forKey: somedateString)
            email.text = dict["email"] as! String
            email.isEnabled = false
            email.backgroundColor = UIColor.lightGray
            //password.text = Auth.auth().currentUser.pass
            password.isEnabled = false
            password.backgroundColor = UIColor.lightGray
            
            if(selectedGender == genderData[0] ){
                gender.selectRow(0, inComponent:0, animated:true)
           
            }
            else  if(selectedGender == genderData[1] ){
                gender.selectRow(1, inComponent:0, animated:true)
           
            }
            
        }
        completionHandler("DONE")
    })
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        //var date = dob.date.dateToString()
        switch cell?.tag ?? 0 {

        case 1:
            print("pick country")
        default:
            print("default")
        }
        tableView.deselectRow(at: indexPath, animated: true);
    }
    

    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
      if segue.identifier == "pickCountry" {
        let controller = segue.destination as!
                         CountrySelector
        controller.selectedCountry = CountryName
        print (CountryName  )
      }
    }
    
    @IBAction func countryPickerDidPickCountry(
                      _ segue: UIStoryboardSegue) {
      let controller = segue.source as! CountrySelector
        CountryName = controller.selectedCountry
        print (CountryName  )
        country.text = CountryName
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderData[row]
    }

  

    @IBAction func pickDate(_ sender: UIDatePicker) {
    print("print \(sender.date)")

        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
        somedateString = dateFormatter.string(from: (sender as AnyObject).date)

            print(somedateString)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
    
        if ProfileViewController.isEdit == false{
            let emailField = email.text
            let passwordField = password.text
            
            print (dob.date)
            
            Auth.auth().createUser(withEmail: emailField!, password: passwordField!) { [self] user, error in
              if user != nil  {
                
                  //self.performSegue(withIdentifier: "profilesetup", sender: nil)
//                  self.email.text = nil
//                  self.password.text = nil
                
                let text = emailField?.components(separatedBy: "@")
                let user = UserList(name: name.text!, dob: somedateString, gender: selectedGender, country: country.text!,mobile:mobile.text!, email: email.text!)
                let userRef = ProfileViewController.UserRef.child((text![0].lowercased()))
                userRef.setValue(user.toAnyObject())
                
                Auth.auth().signIn(withEmail: self.email.text!,
                                   password: self.password.text!)
                
                navigationController?.popViewController(animated: true)
              }
              else{
                let alert = UIAlertController(title: "User creation failed",                                              message:error?.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
                navigationController?.popViewController(animated: true)
              }
            }
        }
            else{
                let emailField = email.text
                let text = emailField?.components(separatedBy: "@")
                let user = UserList(name: name.text!, dob: somedateString, gender: selectedGender, country: country.text!,mobile:mobile.text!, email: email.text!)
                let userRef = ProfileViewController.UserRef.child((text![0].lowercased()))
                userRef.setValue(user.toAnyObject())
                navigationController?.popViewController(animated: true)
            }
            
            
        
    }
}
extension Date {
    
    func formatDate(_ dateStr : String) -> Date{
        let dateObj = DateFormatter()
        dateObj.dateFormat = "dd-MM-yyyy"
        
        if let newDate = dateObj.date(from: dateStr){
            return newDate
        }
     else {
        return self
    }
}
    func dateToString() -> String {
        let dateObj = DateFormatter()
        dateObj.dateFormat = "dd-MM-yyyy"
        return dateObj.string(from: self);
    }
}
