//
//  WLNavigation.swift
//  wallet_LHV
//
//  Created by Mac on 3/1/22.
//

import Foundation
import UIKit

class WLNavigation: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        self.navigationBar.isHidden = false
        self.navigationBar.tintColor = .white
        self.navigationBar.isTranslucent = false
    }
    
}
