//
//  PropertiesList.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-03-31.
//

import Foundation
import Firebase
//import FirebaseDatabase


struct PropertiesList {
  
    let ref: DatabaseReference?
    let key: String
    let propertyID: String
    let owner: String
    let price: Int
    let contact: String
    let city: String
    let address: String
    let pincode: String
    let availabitity: String
    let bedrooms: Int
    let bathrooms: Int
    let parking: Int
    let age: Int
    let size: Int
    let description: String
    let image: String

    
    
    init(key: String = "" , propertyID : String , owner : String , price: Int ,contact: String, city: String , address: String ,pincode : String, availabitity:String, bedrooms:Int , bathrooms: Int , parking: Int , age: Int , size: Int , description : String ,image : String){
        self.ref = nil
        self.key = key
        self.propertyID = propertyID
        self.owner = owner
        self.price = price
        self.contact = contact
        self.city = city
        self.pincode = pincode
        self.address = address
        self.availabitity = availabitity
        self.bedrooms = bedrooms
        self.bathrooms = bathrooms
        self.parking = parking
        self.age = age
        self.size = size
        self.description = description
        self.image = image
       
        
    }
    
    init?(snapshot: DataSnapshot) {
      guard
        let value = snapshot.value as? [String: AnyObject],
        let propertyID = value["propertyID"] as? String,
        let owner = value["owner"] as? String,
        let price = value["price"] as? Int,
        let contact = value["contact"] as? String,
        let pincode = value["pincode"] as? String,
        let city = value["city"] as? String,
        let address = value["address"] as? String,
        let availabitity = value["availabitity"] as? String,
        let bedrooms = value["bedrooms"] as? Int,
        let bathrooms = value["bathrooms"] as? Int,
        let parking = value["parking"] as? Int,
        let age = value["age"] as? Int,
        let size = value["size"] as? Int,
        let description = value["description"] as? String,
        let image = value["image"] as? String
    
      
      else{
        return nil
      }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.owner = owner
        self.propertyID = propertyID
        self.price = price
        self.contact = contact
        self.city = city
        self.address = address
        self.availabitity = availabitity
        self.bedrooms = bedrooms
        self.bathrooms = bathrooms
        self.pincode = pincode
        self.parking = parking
        self.age = age
        self.size = size
        self.description = description
        self.image = image
     

    }
    
    func toAnyObject() -> Any {
      return [
        "owner": owner,
        "propertyID" : propertyID,
        "price" : price,
        "contact" : contact,
        "city" : city,
        "address" : address,
        "availabitity" : availabitity,
        "bedrooms" : bedrooms,
        "pincode" : pincode,
        "bathrooms" :bathrooms,
        "parking" : parking,
        "age" : age,
        "size" : size,
        "description" : description,
        "image" : image,
 
        ]
    }
}
