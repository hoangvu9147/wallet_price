//
//  WalletResponseType.swift
//  wallet_LHV
//
//  Created by Mac on 2/28/22.
//

import Foundation
import SwiftyJSON
import UIKit

public enum WLResponseType: String {
    case json = "JSON"
    case text     = "TEXT"
    case xml    = "XML"
}
class WLResponse {
    var httpStatusCode = 0
    var dataResponse: Any
    var responseType:WLResponseType
    var messError = ""
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    required init(errHTTP: String , statusCode : Int, responseData:Any,responseType:WLResponseType) {
        self.dataResponse = responseData
        self.responseType = responseType
        self.httpStatusCode = statusCode
        self.messError = errHTTP
        //maintent
          if Utils.isValidStatusCodeSuccess(self.httpStatusCode){
            parserCommon()
        }
        else {
//            let messErr =  self.messError
            return
        }
        
    }
    
    func toResponse<T:WLResponse>(clazz: T.Type)->T{
        let object:T = clazz.init(errHTTP:messError , statusCode: httpStatusCode, responseData: dataResponse, responseType: responseType)
        object.parser()
        return object
    }
    
    func parser() {
        
    }
    
    func parserCommon() {
        
    }
}
