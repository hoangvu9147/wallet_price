//
//  WLHeaderPriceView.swift
//  wallet_LHV
//
//  Created by Mac on 3/5/22.
//

import UIKit

class WLHeaderPriceView: UIView {
    
    //SGD
    @IBOutlet weak var lbTypePrice: UILabel!
    @IBOutlet weak var imgDownSGD: UIImageView!
    
    //Price
    @IBOutlet weak var imgUpPrice: UIImageView!
    @IBOutlet weak var imgDownPrice: UIImageView!
    
    //Avaliable
    @IBOutlet weak var imgUpAvaliable: UIImageView!
    @IBOutlet weak var imgDownAvaliable: UIImageView!
    
    var indexPrice = 0
    
    //callback
    var _onClickSGD:((UIButton)->())?
    var _onClickPrice:((Int)->())?
    var _onClickAvaliable:(()->())?
    
    
    class func getScreen(frame: CGRect) -> WLHeaderPriceView {
        let xib = Bundle.main.loadNibNamed(String(describing :self), owner: self, options: nil)
        let me = xib![0] as! WLHeaderPriceView
        me.frame = frame
        return me
    }
    
    func initUI(){
        imgDownSGD.image = imgDownSGD.image?.withRenderingMode(.alwaysTemplate)
        imgDownSGD.tintColor = UIColor.lightGray
        
        imgUpPrice.image = imgUpPrice.image?.withRenderingMode(.alwaysTemplate)
        imgUpPrice.tintColor = UIColor.lightGray
        imgDownPrice.image = imgDownPrice.image?.withRenderingMode(.alwaysTemplate)
        imgDownPrice.tintColor = UIColor.lightGray
        
        imgUpAvaliable.image = imgUpAvaliable.image?.withRenderingMode(.alwaysTemplate)
        imgUpAvaliable.tintColor = UIColor.lightGray
        imgDownAvaliable.image = imgDownAvaliable.image?.withRenderingMode(.alwaysTemplate)
        imgDownAvaliable.tintColor = UIColor.lightGray
        
    }
    
    func setColorCounterPrice(cl : UIColor ){
        imgDownSGD.image = imgDownSGD.image?.withRenderingMode(.alwaysTemplate)
        imgDownSGD.tintColor = cl
    }
}

extension WLHeaderPriceView {
    @IBAction func onSGD(_ sender : UIButton?){
        setColorCounterPrice(cl: UIColor.black)
        _onClickSGD?(sender!)
    }
    
    @IBAction func onPriceUpOrDown(_ sender : Any?){
        imgUpPrice.image = imgUpPrice.image?.withRenderingMode(.alwaysTemplate)
        imgDownPrice.image = imgDownPrice.image?.withRenderingMode(.alwaysTemplate)
        if indexPrice == 0 {
            //Up
            indexPrice = 1
            imgUpPrice.tintColor = UIColor.black
            imgDownPrice.tintColor = UIColor.lightGray
            
        }else if indexPrice == 1 {
            // Down
            indexPrice = 2
            imgUpPrice.tintColor = UIColor.lightGray
            imgDownPrice.tintColor = UIColor.black
        }else {
            // Real
            indexPrice = 0
            imgUpPrice.tintColor = UIColor.lightGray
            imgDownPrice.tintColor = UIColor.lightGray
        }
        
        
        _onClickPrice?(indexPrice)
    }
    
    @IBAction func onAvaliableUpOrDown(_ sender : Any?){
        _onClickAvaliable?()
    }
}
