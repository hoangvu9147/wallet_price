//
//  WLIntroPriceCell.swift
//  wallet_LHV
//
//  Created by Mac on 3/5/22.
//

import UIKit

class WLIntroPriceCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbBuyPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var priceObject : PirceObject! {
        didSet {
            DispatchQueue.main.async { [self] in
                imgIcon.sd_setImage(with: URL(string:  priceObject.icon))
                lbName.text = priceObject.base
                lbBuyPrice.text = priceObject.buy_price + "  SGD"
            }
            
        }
        
    }
    
}
