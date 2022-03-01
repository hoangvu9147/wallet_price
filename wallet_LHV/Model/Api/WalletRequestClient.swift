//
//  WalletRequestClient.swift
//  wallet_LHV
//
//  Created by Mac on 2/28/22.
//

import Foundation
public enum FMMRequestName: String {
    case  GET_All_Price = "/v3/price/all_prices_for_mobile?counter_currency=USD"
}

class WalletRequest: WLRequest {

    override init(requestName: String, responseType: WLResponseType?) {
        super.init(requestName: requestName, responseType: responseType)
    }
                         

    func setHeader(isSet:Bool = true) {

    }
    
    override func getDomain() -> String {
        return "https://www.coinhako.com/api"
    }
    
    

    override func getPath() -> String? {
        return nil
    }

}
