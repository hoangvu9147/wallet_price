//
//  WLHomeVC.swift
//  wallet_LHV
//
//  Created by Mac on 3/1/22.
//

import UIKit

class WLHomeVC: UIViewController {

    @IBOutlet weak var tbHomePrice: UITableView!
    @IBOutlet weak var uiNoData: UIView!
    
    var priceObjs = [PirceObject]()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var presenter : PresenterBase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// init prensenter
        presenter =  PresenterBase(viewController: self)
        self.navigationController?.isNavigationBarHidden = true
        initUI()
        initUINoData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //cal api
        getContentAPIPriceHome() { (_priceObjs) in
            self.priceObjs.removeAll()
            self.priceObjs = _priceObjs
            self.uiNoData.isHidden = self.priceObjs.count > 0 ? true : false
            self.tbHomePrice.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

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
    
    func initUINoData(){
    }
   
    
    
}
//MARK: CALL API
extension WLHomeVC {
    func getContentAPIPriceHome( completion: @escaping ([PirceObject]) -> ()) {
        self.presenter.getDataApiPrice(){ (priceObjs) in
            completion(priceObjs!)
        }
    }
}

extension WLHomeVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceObjs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = self.tbHomePrice.dequeueReusableCell(withIdentifier: "WLPriceHomeTBCell", for: indexPath) as? WLPriceHomeTBCell else {
            return UITableViewCell()
        }
        
        cell.priceObject = priceObjs[indexPath.row]
        return cell
    }
    
}

