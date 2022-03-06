//
//  WLHomeVC.swift
//  wallet_LHV
//
//  Created by Mac on 3/1/22.
//

import UIKit
import DropDown

class WLHomeVC: UIViewController {

    @IBOutlet weak var tbHomePrice: UITableView!
    @IBOutlet weak var uiNoData: UIView!
    @IBOutlet weak var uiHeaderView: UIView!
    @IBOutlet weak var uiBGView: UIView!
    @IBOutlet weak var uiBGHeaderTool: UIView!
    @IBOutlet weak var lbCounterPrice: UILabel!
    
    var uiHeaderPriceView : WLHeaderPriceView! = nil
    
    var priceObjs = [PirceObject]()
    let dropDown = DropDown()
    var typePrice = "USD"
    var indexPrice = 0
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var presenter : PresenterBase!
    
    // needed to keep connection alive
    private var pingTimer: Timer?
    // TODO: make injectable on server creation
    private let pingInterval: TimeInterval = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// init prensenter
        presenter =  PresenterBase(viewController: self)
        self.navigationController?.isNavigationBarHidden = true
        //cal api
        initUI()
        initUIHeaderPriceTool()
        uiHeaderBoder()
        getContentAPIPriceHome()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        DispatchQueue.main.async{
            self.pingTimer = Timer.scheduledTimer(withTimeInterval: self.pingInterval,
                                                  repeats: true) { [weak self] _ in
                print("WC: ==> ping")
                self?.getContentAPIPriceHome()
            }
        }
        print("WC: <== connected")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pingTimer?.invalidate()
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
    
    func uiHeaderBoder(){
//        let shadowView = UIView()
        uiHeaderView.translatesAutoresizingMaskIntoConstraints = true
        uiHeaderView.backgroundColor = UIColor(red: 57/255.0, green: 109/255.0, blue: 216/255.0, alpha: 1.0) /// put the background color here instead of on `titleView`, because this view stretches beyond the notch
        uiHeaderView.layer.shadowColor = UIColor.black.cgColor
        uiHeaderView.layer.shadowOpacity = 0.1
        uiHeaderView.layer.shadowOffset = CGSize(width: 5, height: 3)
//        uiHeaderView.layer.shadowRadius = 0.02
        uiHeaderView.layer.cornerRadius = 30
        uiHeaderView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] /// only round the bottom corners
        self.uiBGView.addSubview(uiHeaderView)
        
        
        NSLayoutConstraint.activate([
            /// constrain `shadowView`
            uiHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            uiHeaderView.rightAnchor.constraint(equalTo: view.rightAnchor),
            uiHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor),
            
        ])
    }
    
}

//MARK: UI Customer
extension WLHomeVC {
    func initUIHeaderPriceTool(){
        uiHeaderPriceView = WLHeaderPriceView.getScreen(frame: CGRect(x:0, y:0, width:self.uiBGHeaderTool.frame.width, height: self.uiBGHeaderTool.frame.height))
        uiHeaderPriceView._onClickSGD = { [weak self] (sender) in
            guard let _ = self else { return }
            self!.dropDown.dataSource = ["SGD", "USD"]
            self!.dropDown.anchorView = sender
            self!.dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
            self!.dropDown.show()
            self!.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
              guard let _ = self else { return }
                self!.uiHeaderPriceView.lbTypePrice.text = item
                self!.uiHeaderPriceView.setColorCounterPrice(cl: UIColor.lightGray)
                self!.typePrice = item
                self!.getContentAPIPriceHome()
               }
             }
        uiHeaderPriceView._onClickPrice = { [weak self] (_indexPrice) in
            self?.indexPrice = _indexPrice
            self!.getContentAPIPriceHome()
        }
        
        self.uiBGHeaderTool.addSubview(uiHeaderPriceView)
    }
}


//MARK: CALL API
extension WLHomeVC {
    func getContentAPIPriceHome() {
        self.presenter.getDataApiPrice(tPrice: self.typePrice){ (_priceObjs) in
            DispatchQueue.main.async {
                guard _priceObjs != nil
                else {
                    return
                }
                self.lbCounterPrice.text = self.typePrice
                self.priceObjs.removeAll()
                self.priceObjs = _priceObjs!
                if self.indexPrice == 1 {
                    self.priceObjs = self.priceObjs.sorted(by: { $0.buy_price.toInt()! > $1.buy_price.toInt()! })
                }else if self.indexPrice == 2 {
                    self.priceObjs = self.priceObjs.sorted(by: { $0.buy_price.toInt()! < $1.buy_price.toInt()! })
                }
                
                self.uiNoData.isHidden = self.priceObjs.count > 0 ? true : false
                self.tbHomePrice.reloadData()
            }
        }
    }
}
//MARK: Action
extension WLHomeVC {
    @IBAction func onSearch(_ sender: UIButton) {
        let vc = WLSeachNamePriceVC()
        vc.priceObjsOld = self.priceObjs
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Delegate Tableview Datasource
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

