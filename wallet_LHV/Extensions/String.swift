//
//  String.swift
//  wallet_LHV
//
//  Created by Mac on 3/5/22.
//

import Foundation

extension String {
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
}

extension String {
        //Converts String to Int
        public func toInt() -> Int? {
            if let num = NumberFormatter().number(from: self) {
                return num.intValue
            } else {
                return nil
            }
        }

        //Converts String to Double
        public func toDouble() -> Double? {
            if let num = NumberFormatter().number(from: self) {
                return num.doubleValue
            } else {
                return nil
            }
        }

        /// EZSE: Converts String to Float
        public func toFloat() -> Float? {
            if let num = NumberFormatter().number(from: self) {
                return num.floatValue
            } else {
                return nil
            }
        }

        //Converts String to Bool
        public func toBool() -> Bool? {
            return (self as NSString).boolValue
        }
    }
