//
//  BuyPointsCollectionViewController.swift
//  Trendin
//
//  Created by Rockson on 31/10/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

var sharedSecret = "d15077ddf1e541c689b708a74132960d"

enum RegisteredPurchase: String {

    case buy100Points = "com.RockzAppSudio.Trendine.100points"
    case buy200Points = "com.RockzAppSudio.Trendine.200points"
    case buy300Points = "com.RockzAppSudio.Trendine.300points"
    case buy400Points = "com.RockzAppSudio.Trendine.400points"
    case buy500Points = "com.RockzAppSudio.Trendine.500points"
    case buy600Points = "com.RockzAppSudio.Trendine.600points"
    case buy1000Points = "com.RockzAppSudio.Trendine.1000points"
    case buy2000Points = "com.RockzAppSudio.Trendine.2000points"
    case buy3000Points = "com.RockzAppSudio.Trendine.3000points"
    case buy4000Points = "com.RockzAppSudio.Trendine.4000points"
    case buy5000Points = "com.RockzAppSudio.Trendine.5000points"
    case buy6000Points = "com.RockzAppSudio.Trendine.6000points"
    case buy7000Points = "com.RockzAppSudio.Trendine.7000points"
    case buy8000Points = "com.RockzAppSudio.Trendine.8000points"
    case buy9000Points = "com.RockzAppSudio.Trendine.9000points"
    case buy10000Points = "com.RockzAppSudio.Trendine.10000points"
   
}

class NetworkActivityIndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted(){
        
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        loadingCount += 1
    }
    
    
    class func NetworkOperationFinished(){
        
        if loadingCount > 0 {
            
            loadingCount -= 1
        }
        
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        
    }
    
}

class BuyPointsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    private let reuseIdentifier = "Cell"
    
 //com.RockzAppSudio.Trendine.points
    
    var bundleID = "com.RockzAppSudio.Trendine"
    var buy100Points = RegisteredPurchase.buy100Points

    var objects = [points]()
    
    let backgroundV: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor.white
        return bView
        
    }()
    
    let BackgroundImageView: customImageView = {
        let imageV = customImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.clipsToBounds = true
        return imageV
        
    }()
    
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    
    let fetchingInfolurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    
    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
        
    }()
 
    
    var lists = [SKProduct]()
    var product = SKProduct()
    var purchasedAmout: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(fetchingInfolurView)
        fetchingInfolurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        fetchingInfolurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        fetchingInfolurView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fetchingInfolurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        fetchingInfolurView.addSubview(activityIndicator)
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        activityIndicator.startAnimating()
        
        
        self.setUpPoints()
        self.getInfo()
        
        
        
        
        
        collectionView?.backgroundColor = .white
        self.collectionView!.register(BuyPointsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Buy Points"
        
        self.collectionView?.backgroundView = backgroundV
        
        self.backgroundV.addSubview(BackgroundImageView)
        
        BackgroundImageView.topAnchor.constraint(equalTo: backgroundV.topAnchor).isActive = true
        BackgroundImageView.leftAnchor.constraint(equalTo: backgroundV.leftAnchor).isActive = true
        BackgroundImageView.heightAnchor.constraint(equalTo: backgroundV.heightAnchor).isActive = true
        BackgroundImageView.widthAnchor.constraint(equalTo: backgroundV.widthAnchor).isActive = true
        
        
        self.backgroundV.addSubview(blurView)
        
        
        blurView.topAnchor.constraint(equalTo: backgroundV.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: backgroundV.leftAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: backgroundV.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: backgroundV.widthAnchor).isActive = true
        
        if let profileImageData = UserDefaults.standard.object(forKey: "profileImageData") as? NSData {
            
            BackgroundImageView.image = UIImage(data: profileImageData as Data)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setUpPoints(){
        
        self.objects.removeAll(keepingCapacity: true)

        
        let point1 = points()
        point1.amount = "$0.99"
        point1.numberOfPoints = 100
        self.objects.append(point1)
        
        let point111 = points()
        point111.amount = "$1.99"
        point111.numberOfPoints = 200
        self.objects.append(point111)
        
        let point33 = points()
        point33.amount = "$2.99"
        point33.numberOfPoints = 300
        self.objects.append(point33)
        
        let point444 = points()
        point444.amount = "$3.99"
        point444.numberOfPoints = 400
        self.objects.append(point444)
        
        let point2 = points()
        point2.amount = "$4.99"
        point2.numberOfPoints = 500
        self.objects.append(point2)
        
        let point66 = points()
        point66.amount = "$5.99"
        point66.numberOfPoints = 600
        self.objects.append(point66)
        
        let point3 = points()
        point3.amount = "$9.99"
        point3.numberOfPoints = 1000
        self.objects.append(point3)
        
        let point4 = points()
        point4.amount = "$19.99"
        point4.numberOfPoints = 2000
        self.objects.append(point4)
        
        let point5 = points()
        point5.amount = "$29.99"
        point5.numberOfPoints = 3000
        self.objects.append(point5)
        
        let point6 = points()
        point6.amount = "$39.99"
        point6.numberOfPoints = 4000
        self.objects.append(point6)
        
        let point7 = points()
        point7.amount = "$49.99"
        point7.numberOfPoints = 5000
        self.objects.append(point7)
        
        let point8 = points()
        point8.amount = "$59.99"
        point8.numberOfPoints = 6000
        self.objects.append(point8)
        
        let point9 = points()
        point9.amount = "$69.99"
        point9.numberOfPoints = 7000
        self.objects.append(point9)
        
        let point10 = points()
        point10.amount = "$79.99"
        point10.numberOfPoints = 8000
        self.objects.append(point10)
        
        let point11 = points()
        point11.amount = "$89.99"
        point11.numberOfPoints = 9000
        self.objects.append(point11)
        
        let point12 = points()
        point12.amount = "$99.99"
        point12.numberOfPoints = 10000
        self.objects.append(point12)
        
        self.collectionView?.reloadData()
        
        
    }
    
    func displayAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func updateUserPointsAfterPuchase(){
        let currentUser = BmobUser.current()

        
        if var currentPoints = currentUser?.object(forKey: "contestPoints") as? Int {
            
            currentPoints = currentPoints + purchasedAmout
            
            currentUser?.setObject(currentPoints, forKey: "contestPoints")
            currentUser?.updateInBackground(resultBlock: { (success, error) in
                if success {
                    
                    print("points added successfully")
                    self.displayAlert(title: "Success", message: "\(self.purchasedAmout) points was added to your account. Current Balance: \(currentPoints) points")
                    
                    
                    
                }else{
                    
                    self.displayAlert(title: "Error", message: error!.localizedDescription as Any as! String)
                    print("error \(error?.localizedDescription)")
                    
                    
                }
            })
            
        }
        
      
        
    }
    
    
    func getInfo(){
        
//        let productID = bundleID + "." + purchase.rawValue
        
        
        let set: NSSet = NSSet(objects: "com.RockzAppSudio.Trendine.100points","com.RockzAppSudio.Trendine.200points","com.RockzAppSudio.Trendine.300points","com.RockzAppSudio.Trendine.400points","com.RockzAppSudio.Trendine.500points","com.RockzAppSudio.Trendine.600points","com.RockzAppSudio.Trendine.1000points","com.RockzAppSudio.Trendine.2000points","com.RockzAppSudio.Trendine.3000points","com.RockzAppSudio.Trendine.4000points","com.RockzAppSudio.Trendine.5000points","com.RockzAppSudio.Trendine.6000points","com.RockzAppSudio.Trendine.7000points","com.RockzAppSudio.Trendine.8000points","com.RockzAppSudio.Trendine.9000points","com.RockzAppSudio.Trendine.10000points")
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo(set as! Set<String>) { (result) in

         NetworkActivityIndicatorManager.NetworkOperationFinished()
        print(result.retrievedProducts.count)
            
            self.fetchingInfolurView.isHidden = true
            self.activityIndicator.stopAnimating()
            
            let retrievedProducts = result.retrievedProducts
            if retrievedProducts.count > 0 {
                
                self.objects.removeAll(keepingCapacity: true)
               
                for prod in retrievedProducts {
                    
                    if prod.productIdentifier == RegisteredPurchase.buy100Points.rawValue {
                        
                        let point1 = points()
                        point1.amount = prod.localizedPrice
                        point1.numberOfPoints = 100
                        self.objects.append(point1)
                        
                    }
                    
                    
                    if prod.productIdentifier == RegisteredPurchase.buy200Points.rawValue {
                        
                        let point2 = points()
                        point2.amount = prod.localizedPrice
                        point2.numberOfPoints = 200
                        self.objects.append(point2)
                        
                    }
                    
                    
                    if prod.productIdentifier == RegisteredPurchase.buy300Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 300
                        self.objects.append(point3)
                        
                    }
                    
                    if prod.productIdentifier == RegisteredPurchase.buy400Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 400
                        self.objects.append(point3)
                        
                    }
                    
                    if prod.productIdentifier == RegisteredPurchase.buy500Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 500
                        self.objects.append(point3)
                        
                    }
                    
                    if prod.productIdentifier == RegisteredPurchase.buy600Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 600
                        self.objects.append(point3)
                        
                    }
                    
                    
                    if prod.productIdentifier == RegisteredPurchase.buy10000Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 1000
                        self.objects.append(point3)
                        
                    }
                    
                    if prod.productIdentifier == RegisteredPurchase.buy2000Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 2000
                        self.objects.append(point3)
                        
                    }
                    
                    
                    if prod.productIdentifier == RegisteredPurchase.buy3000Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 3000
                        self.objects.append(point3)
                        
                    }
                    
                    
                    if prod.productIdentifier == RegisteredPurchase.buy4000Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 4000
                        self.objects.append(point3)
                        
                    }
                    
                    if prod.productIdentifier == RegisteredPurchase.buy5000Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 5000
                        self.objects.append(point3)
                        
                    }
                    
                    
                    if prod.productIdentifier == RegisteredPurchase.buy6000Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 6000
                        self.objects.append(point3)
                        
                    }
                    
                    
                    
                    if prod.productIdentifier == RegisteredPurchase.buy7000Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 7000
                        self.objects.append(point3)
                        
                    }
                    
                    if prod.productIdentifier == RegisteredPurchase.buy8000Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 8000
                        self.objects.append(point3)
                        
                    }
                    
                    
                    if prod.productIdentifier == RegisteredPurchase.buy9000Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 9000
                        self.objects.append(point3)
                        
                    }
                    
                    
                    if prod.productIdentifier == RegisteredPurchase.buy10000Points.rawValue {
                        
                        let point3 = points()
                        point3.amount = prod.localizedPrice
                        point3.numberOfPoints = 10000
                        self.objects.append(point3)
                        
                    }
                    
                }
                
                
                self.objects.sort{$0.numberOfPoints! < $1.numberOfPoints!}

                DispatchQueue.main.async {
                    
                    self.collectionView?.reloadData()
                }
                
            }
          
//            self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
            
        }
        
    }
    
    
    func purchase(purchase: RegisteredPurchase){
        
//        let productID = bundleID + "." + purchase.rawValue

        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.purchaseProduct(purchase.rawValue) { (result) in
        NetworkActivityIndicatorManager.NetworkOperationFinished()
           
            if case .success(let product) = result{
                print(product.productId)
                
                self.updateUserPointsAfterPuchase()

                
                if product.needsFinishTransaction {
                    
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
//                self.showAlert(alert: self.alertForPurchasedResult(result: result))
                
            }
            
            
            
        
        }
        
        
    }
    
    
    func restorePurchases(){
       NetworkActivityIndicatorManager.NetworkOperationStarted()
       SwiftyStoreKit.restorePurchases(atomically: true) { (result) in
        NetworkActivityIndicatorManager.NetworkOperationFinished()
        
        
        for product in result.restoredProducts {
            
            if product.needsFinishTransaction {
                
              SwiftyStoreKit.finishTransaction(product.transaction)
                
            }
        }
        
       self.showAlert(alert: self.alertForRestorePurchases(result: result))
        
        
        }
        
        
        
    }
   
    func verifyReceipt(){
        
       NetworkActivityIndicatorManager.NetworkOperationStarted()
       SwiftyStoreKit.verifyReceipt(password: sharedSecret) { (result) in
        NetworkActivityIndicatorManager.NetworkOperationFinished()
        
        self.showAlert(alert: self.alertFoVerifyReceipt(result: result))
        
        if case .error(let error) = result {
            
            if case .noReceiptData = error {
                
                self.refreshReceipt()
                
            }
            
        }
        
        
        }
        
        
    }
    
    
    func verifyPurchase(purchase: RegisteredPurchase){
        
        let productID = bundleID + "." + purchase.rawValue

        
      NetworkActivityIndicatorManager.NetworkOperationStarted()
      SwiftyStoreKit.verifyReceipt(password: sharedSecret) { (result) in
      NetworkActivityIndicatorManager.NetworkOperationFinished()
        
        switch result {
            
        case .success(let receipt):
            
           let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
            self.showAlert(alert: self.alertForVerifyPurchase(result: purchaseResult))
            
            
        case .error(let error):
            
            self.showAlert(alert: self.alertFoVerifyReceipt(result: result))
            

        
        }
        
        
        
        

        
        
            
      }
        
//        SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: ReceiptInfo)
      
    }
    
    
    func refreshReceipt(){
        
       SwiftyStoreKit.refreshReceipt { (result) in
        
        
        
        }
        
        
    }
    
    
    
    
   

    
//    func buyPoints(){
//
//        print(product.productIdentifier)
//        
//        let pay = SKPayment(product: product)
//        SKPaymentQueue.default().add(self)
//        SKPaymentQueue.default().add(pay)
//        
//    }
//    
//    
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        
//        print("response received right now....")
//        
//        let myProducts = response.products
//        print(myProducts)
//        print(myProducts.count)
//
//        
//        if myProducts.count > 0 {
//        
//            for singleProduct in myProducts {
//                
//                print(singleProduct.localizedTitle, singleProduct.productIdentifier)
//                print(singleProduct.price)
//                
//                self.lists.append(singleProduct)
//                
//            }
//            
//        }
//    
//        
//    }
//    
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        
//        for transaction in transactions {
//            
//            let trans = transaction as SKPaymentTransaction
//            
//            switch trans.transactionState {
//                
//            case .purchased:
//                
//                print("points have been purchased")
//                
//                let productId = self.product.productIdentifier
//                if productId == "trendineContestPoints" {
//                    
//                    // add points to the current user
//                    
//                    
//                }
//                queue.finishTransaction(trans)
//                
//            case .failed:
//                //transaction failed.
//                //payment was unsuccessfull
//                
//                print("transaction failed \(trans.error?.localizedDescription)")
//                //display and alert
//                
//                queue.finishTransaction(trans)
//
//                
//            default:
//                
//                print("defualt")
//            }
//            
//        }
//    }
//    
//    func finishTransaction(trans: SKPaymentTransaction) {
//        
//      print("transaction finished")
//        
//    }
//    
//    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
//        
//        print("remove queue after transaction complete")
//    }
//    
//    
    func handleBuyPointsButtonTapped(sender: UIButton){
        
        let pts = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: pts){
            
            let selectedItem = self.objects[indexPath.item]
            if let points = selectedItem.numberOfPoints {
                
                switch points {
                    
                case 100:
                    
                    print("buy 0.99")
                    
                    self.purchasedAmout = 100
                    self.purchase(purchase: .buy100Points)
  
                    
                case 200:
                    
                    print("buy 4.99")
                    
                    self.purchasedAmout = 200
                    self.purchase(purchase: .buy200Points)

                    
                case 300:
                    
                    print("buy 9.99")
                    self.purchasedAmout = 300
                    self.purchase(purchase: .buy300Points)

                    
                case 400:
                    
                    print("buy 19.99")
                    self.purchasedAmout = 400
                    self.purchase(purchase: .buy400Points)

                    
                case 500:
                    
                    print("buy 29.99")
                    self.purchasedAmout = 500
                    self.purchase(purchase: .buy500Points)

                    
                    
                case 600:
                    
                    print("buy 39.99")
                    self.purchasedAmout = 600
                    self.purchase(purchase: .buy600Points)

                    
                    
                case 1000:
                    
                    print("buy 49.99")
                    self.purchasedAmout = 1000
                    self.purchase(purchase: .buy1000Points)

                    
                case 2000:
                    self.purchasedAmout = 2000
                    self.purchase(purchase: .buy2000Points)

                    print("buy 59.99")
                    
                    
                case 3000:
                    
                    print("buy 49.99")
                    self.purchasedAmout = 3000
                    self.purchase(purchase: .buy3000Points)

                    
                case 4000:
                    
                    print("buy 49.99")
                    self.purchasedAmout = 4000
                    self.purchase(purchase: .buy4000Points)

                    
                case 5000:
                    
                    print("buy 49.99")
                    self.purchasedAmout = 5000
                    self.purchase(purchase: .buy5000Points)

                    
                case 6000:
                    
                    print("buy 99.99")
                    self.purchasedAmout = 6000
                    self.purchase(purchase: .buy6000Points)

                case 7000:
                    
                    print("buy 99.99")
                    self.purchasedAmout = 7000
                    self.purchase(purchase: .buy7000Points)
                    
                case 8000:
                    
                    print("buy 99.99")
                    self.purchasedAmout = 8000
                    self.purchase(purchase: .buy8000Points)
                    
                    
                case 9000:
                    
                    print("buy 99.99")
                    self.purchasedAmout = 900
                    self.purchase(purchase: .buy9000Points)
                    
                case 10000:
                    
                    print("buy 99.99")
                    self.purchasedAmout = 10000
                    self.purchase(purchase: .buy10000Points)
                    
                    
                default:
                    
                    print("nothing here..")
                }
                
            }
                
            }

           
            
        

        
    }

  
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.objects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BuyPointsCollectionViewCell
        
        let object = self.objects[indexPath.item]
        if let amount = object.amount, let pts = object.numberOfPoints {
            
            cell.amountLabel.text = "\(amount)"
            cell.pointsLabel.text = "\(pts) points"
  
        }
    
        
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        
        cell.buyButton.addTarget(self, action: #selector(handleBuyPointsButtonTapped), for: .touchUpInside)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthAndHeight = self.view.frame.width / 2 - 1
        return CGSize(width: widthAndHeight, height: widthAndHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    


}





extension BuyPointsCollectionViewController {
    
    
    func alertWthTitle(title: String , message: String) -> UIAlertController {
        
       let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        return alert
        
    }
    
    
    func showAlert(alert: UIAlertController){
        
        guard let _ = self.presentedViewController else {
            
            self.present(alert, animated: true , completion: nil)
            
            return
            
        }
        
    }
    
    
    func alertForProductRetrievalInfo(result: RetrieveResults) -> UIAlertController {
        
        let products = result.retrievedProducts
        
        if products.count > 0 {
            
            for product in products {
                
             let priceString = product.localizedPrice!
             return alertWthTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
                
                
            }
            
        }
        
        let invalidProducts = result.invalidProductIDs
        if invalidProducts.count > 0 {
            
            
                return alertWthTitle(title: "Couldn't retrieve product info", message: "Invalid Products ID")
                
            
            
        }
        
        
        let error = result.error
        if error != nil {
            
            return alertWthTitle(title: "Unknown error", message: "Uknown error, please contact support \(error?.localizedDescription)")
            
            
        }
        
            
     return alertWthTitle(title: "Unknown error", message: "Contact support")
        
    }
    
    
    
    func alertForPurchasedResult(result: PurchaseResult) -> UIAlertController {
        
        switch result {
        case .success(let product):
            
        //item has been purchesed successfully
        print("\(product.productId)")
            
        return alertWthTitle(title: "Payment success", message: "Good luck in the Contest")

            
        case .error(let error):
            
            //Payment failed...
            print("payment failed \(error)")
            
            switch error {
            case .failed(let failedError):
                
                if (failedError as NSError).domain == SKErrorDomain {
                    
                    return alertWthTitle(title: "Purchase failed", message: "Check your internet connect or try again later")
                    
                }else{
                    
                    return alertWthTitle(title: "Purchase Failed", message: "Contact support")
                    
                }
                
            case .invalidProductId(productId: let prodID):
                
                return alertWthTitle(title: "Purchase failed", message: "Product ID invalid \(prodID), contact support")
                
            case .noProductIdentifier:
                
                return alertWthTitle(title: "Purchase failed", message: "No product ID, contact support")
                
            case .paymentNotAllowed:
                
                return alertWthTitle(title: "Purchase failed", message: "Payment is not allowed on your device. Enable payment in the Settings")
            }
            
       
        }
        
        
    }
    
    
    
    func alertFoVerifyReceipt(result: VerifyReceiptResult) -> UIAlertController{
        
        switch result {
        case .success(let receipt):
            
         return alertWthTitle(title: "Receipt verified", message: "Receipt successfully verified")
            
            
        case .error(let error):
            
            switch error {
            case .noReceiptData:
                
             return alertWthTitle(title: "Receipt verification failed", message: "Receipt data was not found. Try again")
               
            default:
                
                return alertWthTitle(title: "Verification failed", message: "Receipt verification failed")
            }
            
        
        
        }
        
        
    }
    
    
    func alertForRestorePurchases(result: RestoreResults) -> UIAlertController {
        
        if result.restoredProducts.count > 0 {
            
            print(result.restoreFailedProducts)
            
            
            return alertWthTitle(title: "Unknown Error", message: "Contact suppport")
            
        }else if result.restoreFailedProducts.count > 0 {
            
            
            return alertWthTitle(title: "Purchases Restored", message: "Purchases have been restored")
        }else{
            
            
            return alertWthTitle(title: "No Purchases", message: "No purchases yet")
        }
        
    }
    
    
    func alertForVerifyPurchase(result: VerifyPurchaseResult) -> UIAlertController{
        
        switch result {
        case .purchased:
            
            return alertWthTitle(title: "Purchase successful", message: "Purchase verified successfully")
        case .notPurchased:
            
            return alertWthTitle(title: "Product not purchased", message: "Product is not yet purchased")
            
        }
       
        
    }
    
}












