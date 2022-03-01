//
//  WLPriceHomeTBCell.swift
//  wallet_LHV
//
//  Created by Mac on 3/1/22.
//

import UIKit
import SDWebImage

class WLPriceHomeTBCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbSellPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCounter: UILabel!
    @IBOutlet weak var lbBuyPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var priceObject : PirceObject! {
        didSet {
            DispatchQueue.main.async { [self] in
                imgIcon.sd_setImage(with: URL(string:  priceObject.icon))
                lbName.text = priceObject.base
                lbBuyPrice.text = priceObject.buy_price
                lbSellPrice.text = priceObject.sell_price
            }
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
