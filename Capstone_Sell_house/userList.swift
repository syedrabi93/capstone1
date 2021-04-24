//
//  userList.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-03-27.
//

import Foundation
import Firebase
//import FirebaseDatabase


struct UserList {
  
    let ref: DatabaseReference?
    let key: String
    let name: String
    let dob: String
    let gender: String
    let mobile: String
    let country: String
    let email: String
    
    
    init(key: String = "" , name : String , dob: String , gender: String , country: String , mobile:String, email:String){
        self.ref = nil
        self.key = key
        self.name = name
        self.dob = dob
        self.gender = gender
        self.country = country
        self.mobile = mobile
        self.email = email
    }
    
    init?(snapshot: DataSnapshot) {
      guard
        let value = snapshot.value as? [String: AnyObject],
        let name = value["name"] as? String,
        let dob = value["dob"] as? String,
        let country = value["country"] as? String,
        let gender = value["gender"] as? String,
        let mobile = value["mobile"] as? String,
        let email = value["email"] as? String
      else{
        return nil
      }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.dob = dob
        self.gender = gender
        self.country = country
        self.mobile = mobile
        self.email = email
    }
    
    func toAnyObject() -> Any {
      return [
        "name": name,
        "dob" : dob,
        "gender" : gender,
        "country" : country,
        "mobile" : mobile,
        "email" : email
        ]
    }
}

