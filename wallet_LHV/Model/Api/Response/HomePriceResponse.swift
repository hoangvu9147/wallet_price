//
//  HomePriceResponse.swift
//  wallet_LHV
//
//  Created by Mac on 3/1/22.
//

import Foundation
import SwiftyJSON

/*
 var base  = ""
 var counter  = ""
 var buy_price  = ""
 var sell_price = ""
 var icon = ""
 var name = ""
 */

class HomePriceResponse: NSObject {
    
    func parserHomePrice(dataResponse: Any) -> [PirceObject]{
        let responseJson = dataResponse as!JSON
        var priceObjs = [PirceObject]()

        if !Utils.isEmptyJson(json: responseJson, key: "data") {
            print("-----value content---- responseJson media \(responseJson)")
            let arr_json = responseJson["data"].array
            for jPrice in arr_json! {
                let priceData = PirceObject()
                
                if !Utils.isEmptyJson(json: jPrice, key: "base") {
                    priceData.base = jPrice["base"].string!
                }
                if !Utils.isEmptyJson(json: jPrice, key: "counter") {
                    priceData.counter = jPrice["counter"].string!
                }
                if !Utils.isEmptyJson(json: jPrice, key: "buy_price") {
                    priceData.buy_price = jPrice["buy_price"].string!
                }
                if !Utils.isEmptyJson(json: jPrice, key: "sell_price") {
                    priceData.sell_price = jPrice["sell_price"].string!
                }
                if !Utils.isEmptyJson(json: jPrice, key: "icon") {
                    priceData.icon = jPrice["icon"].string!
                }
                if !Utils.isEmptyJson(json: jPrice, key: "name") {
                    priceData.name = jPrice["name"].string!
                }
                
                priceObjs.append(priceData)
            }
        }

        return priceObjs
    }
}
