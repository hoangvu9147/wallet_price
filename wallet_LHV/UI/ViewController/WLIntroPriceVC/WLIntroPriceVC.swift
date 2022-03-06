//
//  WLIntroPriceVC.swift
//  wallet_LHV
//
//  Created by Mac on 3/5/22.
//

import UIKit

class WLIntroPriceVC: UIViewController {
    
    @IBOutlet weak var tbHomePrice: UITableView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    var priceObjs = [PirceObject]()
    let date = Date()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var presenter : PresenterBase!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// init prensenter
        presenter =  PresenterBase(viewController: self)
        self.navigationController?.isNavigationBarHidden = true
        //cal api
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getContentAPIPriceHome()
        self.lbTime.text = date.getFormattedDate(format: "h:mm a")
        self.lbDate.text = date.getFormattedDate(format: "E, d MMM")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    func initUI(){
        self.tbHomePrice.register(UINib(nibName: "WLIntroPriceCell", bundle: nil), forCellReuseIdentifier: "WLIntroPriceCell")
        
        self.tbHomePrice.dataSource = self
        self.tbHomePrice.delegate = self
        self.tbHomePrice.backgroundColor = UIColor.clear
        self.tbHomePrice.separatorStyle = .none
        self.tbHomePrice.rowHeight = UITableView.automaticDimension
        self.tbHomePrice.estimatedRowHeight = 70

    }
    
    
}

//MARK: Action
extension WLIntroPriceVC {
    @IBAction func onUnlock(_ sender : Any?){
        let vc = WLAuthenNumberVC()
        self.present(vc, animated: true)
    }
}

//MARK: CALL API
extension WLIntroPriceVC {
    func getContentAPIPriceHome() {
        self.presenter.getDataApiPrice(tPrice: "SGD"){ (_priceObjs) in
            DispatchQueue.main.async {
                guard _priceObjs != nil
                else {
                    return
                }
                self.priceObjs.removeAll()
                self.priceObjs = _priceObjs!
                self.priceObjs = self.priceObjs.sorted(by: { $0.buy_price.toInt()! > $1.buy_price.toInt()! })
                self.tbHomePrice.reloadData()
            }
        }
    }
}


//MARK: Delegate Tableview Datasource
extension WLIntroPriceVC: UITableViewDelegate,UITableViewDataSource {
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
        
        guard  let cell = self.tbHomePrice.dequeueReusableCell(withIdentifier: "WLIntroPriceCell", for: indexPath) as? WLIntroPriceCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.priceObject = priceObjs[indexPath.row]
        return cell
    }
    
}
