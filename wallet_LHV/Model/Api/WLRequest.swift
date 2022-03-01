//
//  WalletRequest.swift
//  wallet_LHV
//
//  Created by Mac on 2/28/22.
//

import Foundation
import Alamofire
import SwiftyJSON


class NetworkSection {
    var manager: SessionManager!
    var serverTrustPolicies: [String : ServerTrustPolicy] = [String:ServerTrustPolicy]()
    static let sharedManager = NetworkSection()
    
    init(){
        manager = initUnsafeManager()
    }
    
    //USED FOR SITES WITH CERTIFICATE, OTHERWISE .DisableEvaluation
    func initSafeManager() -> SessionManager {
//        setServerTrustPolicies()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 25 // seconds
        configuration.timeoutIntervalForResource = 25
        manager = SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
        return manager
    }
    
    //USED FOR SITES WITHOUT CERTIFICATE, DOESN'T CHECK FOR CERTIFICATE
    func initUnsafeManager() -> SessionManager {
        manager = Alamofire.SessionManager.default
        
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)     //URLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = self.manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
        
        return manager
    }
    
}


class WLRequest {
    var mParameters: Dictionary = Dictionary<String,Any>()
    var mHeader: HTTPHeaders? = nil
    var mParametersXml : String = ""
    var mMethod: HTTPMethod = .get
    var mResponseType: WLResponseType?
    var mParametersDic = [String:Any]()
    var mParametersObject: [Any] = []
    
    let manager = NetworkSection.sharedManager.manager
    
    var mRequestName: String
    
    
    init(requestName:String,responseType: WLResponseType? = nil) {
        self.mRequestName = requestName;
        if responseType == nil {
            self.mResponseType = .json
        } else {
            self.mResponseType = responseType!
        }
    }
    
    func getDomain() -> String {
        return "";
    }
    
    
    func getPath() -> String? {
        return nil;
    }
    
    func makeUrl() -> String {
        mRequestName == FMMRequestName.GET_All_Price.rawValue
        let url = "\(getDomain())\(mRequestName)"
        print("url -- : \(url)")
        return url
    }
    
    
    func get() -> WLRequest {
        self.mMethod = .get
        return self
    }
    
    func post() -> WLRequest {
        self.mMethod = .post
        return self
    }
    
    func put() -> WLRequest {
        self.mMethod = .put
        return self
    }
    
    func addHeaders(key: String, value: String) {
        if mHeader == nil {
            mHeader = HTTPHeaders()
        }
        mHeader?.updateValue(value, forKey: key)
    }
    
    func addParam(key:String, value : Any) {
        mParameters.updateValue(value, forKey: key)
    }
    
    
    func delete() -> WLRequest {
        self.mMethod = .delete
        return self
    }
    
    func patch() -> WLRequest {
        self.mMethod = .patch
        return self
    }
    
    func execute(mfResponse:@escaping (WLRequest,WLResponse?,Error?)-> Void) {
        
        print(" execute --- Api url: \(makeUrl())")
        do{
            let jsonHeader = try JSONSerialization.data(withJSONObject: mHeader as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonStringHeader = NSString(data: jsonHeader, encoding: String.Encoding.utf8.rawValue)! as String
            print("Api Header: \(jsonStringHeader)")
        }catch {
            print("Api param:  error")
        }
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: mParameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print("--jsonString --Api param: \(jsonString)")
        }catch {
            print("Api param:  error")
        }
        var encode: ParameterEncoding = URLEncoding.default
        if mMethod == .post || mMethod == .put {
            encode = JSONEncoding.default
        }
        
        manager!.request(makeUrl(), method: mMethod, parameters: mParameters, encoding: encode,headers :mHeader).responseJSON { response in
            
            //            if let json = response.result.value {
            //                print("Response JSON: ----- 0o0 ----\n \(json)")
            //            }
            
            //            debugPrint(response)
            //
            //            print(response.request)
            //            print(response.response)
            //            debugPrint(response.result)
            
            switch response.result {
            case .success:
                
                do{
                    if Utils.isEmptyObject( response.result.value) {
                          mfResponse(self,WLResponse(errHTTP: "", statusCode: response.response!.statusCode,responseData:response, responseType: WLResponseType.json),nil)
                    }else {
                        let result:JSON = try JSON(data: response.data!)
                        mfResponse(self,WLResponse(errHTTP: "",statusCode: response.response!.statusCode,responseData:result, responseType: WLResponseType.json),nil)
                    }
                    
//                    print("Api response:\((result as AnyObject))")
                    
                } catch {
                    debugPrint("Api response: convert json error")
                }
                
            case .failure(let error):
                print("error -- \(error.localizedDescription)")
                var messErr = ""
                if !Utils.isEmptyObject(response.response?.allHeaderFields["x-message-info"] as? String) {
                    messErr = (response.response?.allHeaderFields["x-message-info"] as? String)!
                }
                print("messErr -- \(messErr)")
                
                if response.response != nil {
                    mfResponse(self,WLResponse(errHTTP: messErr, statusCode: 400,responseData:response, responseType: WLResponseType.json),nil)
                }
                else{
                     mfResponse(self,nil,error)
                }
               
            }
        }
        
    }
    
    
}

