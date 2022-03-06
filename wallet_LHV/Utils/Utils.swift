//
//  Utils.swift
//  wallet_LHV
//
//  Created by Mac on 2/28/22.
//

import Foundation
import UIKit
import SwiftyJSON
import AVKit
import AVFoundation
import SystemConfiguration
import CryptoSwift

class Utils {
    
    static func isValidStatusCodeSuccess(_ code: Int) -> Bool {
        return (200..<299).contains(code)
    }
    
    static func isEmptyObject(_ obj: Any) -> Bool {
        if (obj is NSNull) || ((obj as AnyObject).isEqual(NSNull())){
            return true
        }
        else if (obj is String) {
            let string: String? = (obj as? String)
            if (string?.count ?? 0) == 0 || (string == "") || (string == "(null)") || (string == nil) || (string == "<null>") || (string == "null") || (string?.replacingOccurrences(of: " ", with: "") == "") {
                return true
            }
        }
        return false
    }
    
    static func isEmptyJson(json:JSON,key:String)->Bool{
        if json[key].exists() {
            if json[key].type == SwiftyJSON.Type.null {
                return true
            }
            return false
        } else {
            return true
        }
    }
    
    static  func isInternetAvailble() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}
