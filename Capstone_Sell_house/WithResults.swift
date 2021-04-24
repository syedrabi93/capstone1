//
//  WithResults.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-04-04.
//

import UIKit

protocol wishlist: class {
    func wishListSelection(sender: WithResults)
}

class WithResults: UITableViewCell {

    
    var delegate : wishlist?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
        userImage?.contentMode = .scaleAspectFit
        userImage?.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var Parking: UILabel!
    @IBOutlet weak var Bedroom: UILabel!
    @IBOutlet weak var Bathroom: UILabel!
    @IBOutlet weak var Availability: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var wishlist: UIButton!
    @IBAction func addToWishList(_ sender: UIButton) {
        delegate?.wishListSelection(sender: self)
    }
}
