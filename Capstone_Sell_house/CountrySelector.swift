//
//  CountrySelector.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-03-28.
//

import UIKit

class CountrySelector: UITableViewController {
    
    var selectedCountry = ""
    
    let countryList = ["Australia" ,"Bangladesh" , "Canada","China" ,"Dubai","England" ,"Finland", "France" ,"India", "Malaysia" ,  "Mexico" ,    "New Zealand" ,"Pakistan" , "Sinagpore" ,  "Saudi" ,   "Swizerland" ,"Quatar" ,"Vietnam" , "USA"]
    
    var selectedIndexPath: IndexPath?;
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<countryList.count {
              if countryList[i] == selectedCountry {
                selectedIndexPath = IndexPath(row: i, section: 0)
                break
              }
            
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
            numberOfRowsInSection section: Int) -> Int {
        return countryList.count
      }

    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) ->
                   UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                             withIdentifier: "Cell",
                                        for: indexPath)
        
        let categoryName = countryList[indexPath.row]
        cell.textLabel!.text = categoryName
        if categoryName == selectedCountry {
          cell.accessoryType = .checkmark
    } else {
          cell.accessoryType = .none
        }
    return cell
        
    }
    
    override func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
        
        if(selectedIndexPath == nil){
            if let newCell = tableView.cellForRow(at: indexPath) {
              newCell.accessoryType = .checkmark
            }
            selectedIndexPath = indexPath;
        }else {
            if(indexPath.row == selectedIndexPath?.row){
                if let newCell = tableView.cellForRow(at: indexPath) {
                  newCell.accessoryType = .none
                }
                selectedIndexPath = nil
            }else {
                if let newCell = tableView.cellForRow(at: indexPath) {
                  newCell.accessoryType = .checkmark
                    
                }
                if let oldCell = tableView.cellForRow(
                                 at: selectedIndexPath!) {
                    oldCell.accessoryType = .none
                    
                }
                selectedIndexPath = indexPath;
                
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
      if segue.identifier == "pickedCountry" {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
          selectedCountry = countryList[indexPath.row]
            print (selectedCountry  )
        }
    }
        
    }

}
