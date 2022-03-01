//
//  HomePriceRequest.swift
//  wallet_LHV
//
//  Created by Mac on 3/1/22.
//

import Foundation

class HomePriceRequest : WalletRequest {
    
    override init(requestName: String, responseType: WLResponseType? = nil) {
        super.init(requestName: requestName,responseType: responseType)
        addHeaders(key: "accept",value: "application/json")
    }
    
}
