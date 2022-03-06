//
//  NSDate.swift
//  wallet_LHV
//
//  Created by Mac on 3/6/22.
//

import Foundation
import UIKit

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
