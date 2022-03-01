//
//  PresenterBase.swift
//  wallet_LHV
//
//  Created by Mac on 3/1/22.
//


import Foundation
import UIKit
import MBProgressHUD


class PresenterBase {
    var viewController:UIViewController
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(viewController:UIViewController) {
        self.viewController = viewController
    }
    
    
    //MARK: - Dialog Arler
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.viewController.present(alert, animated: true, completion: nil)
    }
    
    ///MARK:  REST API Price
    // presenter load method get api
    func getDataApiPrice(completion: @escaping ([PirceObject]?) -> ()){
        if Utils.isInternetAvailble()  {
            let api = HomePriceRequest(requestName: String(format: FMMRequestName.GET_All_Price.rawValue), responseType: WLResponseType.json)
            MBProgressHUD.showAdded(to: self.viewController.view, animated: true)
            
            api.get().execute {
                (api,response,error) in
                MBProgressHUD.hide(for: self.viewController.view, animated: true)
                
                if response != nil && Utils.isValidStatusCodeSuccess(response!.httpStatusCode) {
                    let priceObjs = HomePriceResponse().parserHomePrice(dataResponse: response?.dataResponse)
                    completion(priceObjs)
                }
                else if response == nil  {
                    self.showAlert(withTitle: "Error", andMessage: "Can not connect server!")
                    completion(nil)
                }
            }
        }else {
            self.showAlert(withTitle: "Error", andMessage: "Can not connect server!")
            completion(nil)
        }
       
    }
}

