//
//  SettingApp.swift
//  wallet_LHV
//
//  Created by Mac on 3/6/22.
//

import Foundation

class SettingApp {
    
    static let instance = SettingApp()
    private init(){}
    
    //PIN VAKUE
    func setValueKeyASE256(value: String)  {
        let defaults = UserDefaults.standard
        defaults.set( value, forKey: Constants.kAES256_32Bytes)
        defaults.synchronize()
    }

    func getValueKeyASE256() -> String {
        if let value = UserDefaults.standard.string(forKey: Constants.kAES256_32Bytes) {
            return value
        } else {
            return ""
        }
    }
    
    
    func setValueAuthenLocal(value: String)  {
        do {
            let aes = try AES(keyString: SettingApp.instance.getValueKeyASE256())
            let stringToEncrypt: String = value
            let encryptedData: Data = try aes.encrypt(stringToEncrypt)
            print("String encrypted (base64):\t\(encryptedData.base64EncodedString())")
            
            let defaults = UserDefaults.standard
            defaults.set( encryptedData, forKey: Constants.kAuthenData)
            defaults.synchronize()
        } catch {
            print("Something went wrong: \(error)")
        }
        
       
    }
    
    func getValueAuthenLocal() -> String {
        do {
            if UserDefaults.standard.data(forKey: Constants.kAuthenData) != nil {
                
                let aes = try AES(keyString: SettingApp.instance.getValueKeyASE256())
                let decryptedData: String = try aes.decrypt(UserDefaults.standard.data(forKey: Constants.kAuthenData)!)
                print("String decrypted:\t\t\t\(decryptedData)")
                return decryptedData
            }else {
                
                return ""
                
            }
        } catch {
            print("Something went wrong: \(error)")
            return ""
        }
    }
    
    
    //IS LOCK VAKUE
    func setValueIsLock(value: Bool)  {
        let defaults = UserDefaults.standard
        defaults.set( value, forKey: Constants.kIsLOCK)
        defaults.synchronize()
    }
    
    func getValueIsLock() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.kIsLOCK)
    }
    
    
    //Private Key
    func setValuePrivateKey(value: String)  {
        let defaults = UserDefaults.standard
        defaults.set( value, forKey: Constants.kPrivateKey)
        defaults.synchronize()
    }
    
    func getValuePrivateKey() -> String {
        if let value = UserDefaults.standard.string(forKey: Constants.kPrivateKey) {
            return value
        } else {
            return ""
        }
    }
    
    
    //Publish Key
    func setValuePublishKey(value: String)  {
        let defaults = UserDefaults.standard
        defaults.set( value, forKey: Constants.kPublicKey)
        defaults.synchronize()
    }
    
    func getValuePublishKey() -> String {
        if let value = UserDefaults.standard.string(forKey: Constants.kPublicKey) {
            return value
        } else {
            return ""
        }
    }
}
