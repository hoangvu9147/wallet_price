//
//  WLSeachNamePriceVC.swift
//  wallet_LHV
//
//  Created by Mac on 3/1/22.
//

import UIKit

class WLSeachNamePriceVC: UIViewController {
    var priceObjsOld = [PirceObject]()
    var priceObjsSearch = [PirceObject]()
    
    
    @IBOutlet weak var uiBGTfSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
//    @IBOutlet weak var heightTFSearchConstraint: NSLayoutConstraint!
    @IBOutlet weak var uiSearchBG: UIView!
    @IBOutlet weak var lbNoneData: UILabel!
    @IBOutlet weak var tbHomePrice: UITableView!
    
    @IBOutlet weak var imgSeach: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    
    var search = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tfSearch.delegate = self
        // show keyboard
        tfSearch.becomeFirstResponder()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.priceObjsSearch = self.priceObjsOld
        self.lbNoneData.isHidden = self.priceObjsSearch.count > 0 ? true : false
        self.tbHomePrice.reloadData()
    }
    
    func initUI(){
        self.tbHomePrice.register(UINib(nibName: "WLPriceHomeTBCell", bundle: nil), forCellReuseIdentifier: "WLPriceHomeTBCell")
        
        self.tbHomePrice.register(UINib(nibName: "WLPriceHomeTBCell", bundle: nil), forCellReuseIdentifier: "WLPriceHomeTBCell")
        
        self.tbHomePrice.dataSource = self
        self.tbHomePrice.delegate = self
        self.tbHomePrice.backgroundColor = UIColor.clear
        self.tbHomePrice.separatorStyle = .none
        self.tbHomePrice.rowHeight = UITableView.automaticDimension
        self.tbHomePrice.estimatedRowHeight = 70
        
    }
    
    
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //----0o0------
    @IBAction func onClose(_ sender: UIButton) {
        // Event close
        if imgSeach.image == UIImage(named: "iClose") {
            tfSearch.text = ""
            self.onSearchActionRealm(strSearch: tfSearch.text!,isClose: true)
            view.endEditing(true)
        }
    }
}


//MARK: Delegate Tableview Datasource
extension WLSeachNamePriceVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceObjsSearch.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = self.tbHomePrice.dequeueReusableCell(withIdentifier: "WLPriceHomeTBCell", for: indexPath) as? WLPriceHomeTBCell else {
            return UITableViewCell()
        }
        
        cell.priceObject = priceObjsSearch[indexPath.row]
        return cell
    }
    
}



extension WLSeachNamePriceVC: UITextFieldDelegate{
 
    func onSearchActionRealm(strSearch : String, isClose : Bool = false){
        if self.priceObjsOld.count > 0 {
            let priceObjsSearchNew = self.priceObjsOld.filter({
                return ($0.name).lowercased().contains(search.lowercased())
            })
            
            if strSearch == "" {
                self.priceObjsSearch = self.priceObjsOld
            }else {
                self.priceObjsSearch = priceObjsSearchNew
            }
            
            self.lbNoneData.isHidden = self.priceObjsSearch.count > 0 ? true : false
            
            self.tbHomePrice.reloadData()
        }
        
        //---0o0----
        //Check show close button
        if !isClose {
            imgSeach.image = UIImage(named: "iClose")
        }
        else {
            imgSeach.image = UIImage(named: "iSearch")
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print ("textFieldShouldReturn \(textField.text)")
        self.onSearchActionRealm(strSearch: textField.text!)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print ("textFieldDidBeginEditing -- Nothing to show textView \(textField.text)")
        self.onSearchActionRealm(strSearch: textField.text!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if string.isEmpty
        {
            search = String(search.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        
       
        print ("shouldChangeCharactersIn -- search textView \(search)")
        self.onSearchActionRealm(strSearch: search)
        
        return true
    }
    
}
