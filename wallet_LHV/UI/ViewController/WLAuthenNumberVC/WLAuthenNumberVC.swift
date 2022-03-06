//
//  WLAuthenNumberVC.swift
//  wallet_LHV
//
//  Created by Mac on 3/3/22.
//

import UIKit
import DPOTPView

class WLAuthenNumberVC: UIViewController {

    @IBOutlet weak var tfOTP: DPOTPView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDes: UILabel!
    
    var isCreatePIN = true
    var valuePIN = ""
    var dicPIN = [Int: String]()
    var indexPage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tfOTP.becomeFirstResponder()
        tfOTP.dpOTPViewDelegate = self
        if SettingApp.instance.getValueAuthenLocal() != "" {
            authenticatePIN()
        }else {
            checkCreateNewCodePIN()
        }
        
    }

    func pesentHomeVC(){
        let mySceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        mySceneDelegate.showHomePriceVC()
    }
    
      
}

//MARK: Method Authenticate PIN
extension WLAuthenNumberVC {
    func authenticatePIN(){
        lbTitle.text = "Authentication"
        tfOTP.becomeFirstResponder()
        tfOTP.text = ""
        let errDes = "Incorrect PIN. You will logged out after " + " \(indexPage) " + "incorrect attempts"
        lbDes.text = ""
        
        let pinVl = SettingApp.instance.getValueAuthenLocal()
        if dicPIN[indexPage] != nil && dicPIN[indexPage] == pinVl {
            pesentHomeVC()
        }else if dicPIN[indexPage] != nil && dicPIN[indexPage] != pinVl {
            lbDes.text = errDes
        }
        
        if indexPage > 3 {
            SettingApp.instance.setValueAuthenLocal(value: "")
            checkCreateNewCodePIN()
        }
    }
}
 

//MARK: Method Create PIN
extension WLAuthenNumberVC {
    func checkCreateNewCodePIN(){
        tfOTP.becomeFirstResponder()
        guard SettingApp.instance.getValueAuthenLocal() == "" else {
            return
        }
        dicPIN.removeAll()
        isCreatePIN = true
        indexPage = 0
        lbTitle.text = "Create PIN"
        lbDes.text = ""
    }
    
    func confirmCodePIN(pinCF : String){
        tfOTP.becomeFirstResponder()
        indexPage = 1
        lbTitle.text = "Enter PIN to confirm"
        lbDes.text = ""
        if self.valuePIN.count == 6 && dicPIN[0] == dicPIN[1]{
            SettingApp.instance.setValueAuthenLocal(value: dicPIN[1]!)
            // Navigate Home
            let mySceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
            mySceneDelegate.showHomePriceVC()
        }
        
        else if dicPIN[1] != nil && dicPIN[0] != dicPIN[1] {
            lbDes.text = "PIN code is incorrect"
        }
        
        if indexPage > 2{
            SettingApp.instance.setValueAuthenLocal(value: "")
            checkCreateNewCodePIN()
        }
    }
}


//MARK: Authen PIN
extension WLAuthenNumberVC : DPOTPViewDelegate {
   func dpOTPViewAddText(_ text: String, at position: Int) {
       print("addText:- " + text + " at:- \(position) textlenght \(text.count)" )
       
        self.valuePIN = text
       if text.count == 6 && isCreatePIN{
           if SettingApp.instance.getValueAuthenLocal() != "" {
               indexPage = indexPage + 1
               dicPIN[indexPage] = text
               authenticatePIN()
           }else {
               dicPIN[indexPage] = text
               tfOTP.text = ""
               confirmCodePIN(pinCF: text)
           }
       }
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
    }
}
