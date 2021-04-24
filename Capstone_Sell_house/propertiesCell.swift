//
//  propertiesCell.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-04-09.
//

import UIKit

class propertiesCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var parking: UILabel!
    @IBOutlet weak var bedrooms: UILabel!
    @IBOutlet weak var bathrooms: UILabel!
    @IBOutlet weak var propImage: UIImageView!
    
    
    func initialize(price: String, city: String, availability: String, size: String , parking : String , bedrooms : String , bathrooms: String , propImage: UIImage){
        
        self.price!.text = price
        self.availability!.text = availability
        self.bedrooms!.text = bedrooms
        self.city!.text = city
        self.bathrooms!.text = bathrooms
        self.size!.text = size
        self.parking!.text = parking
        self.propImage!.image = propImage
    }
}
