//
//  CoinShopViewController.swift
//  Apollo 31
//
//  Created by Trevor Stevenson on 7/12/15.
//  Copyright (c) 2015 TStevensonApps. All rights reserved.
//

import UIKit
import Parse
import GameKit

class CoinShopViewController: UIViewController {
    
    var pageIndex: Int!
    var PVC: ShopViewController!
    @IBOutlet weak var coinShopDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.view.frame.size.height == 480
        {
            coinShopDescription.text = "Buy coins to be able to use more power ups."
            coinShopDescription.font = UIFont(name: "Star Jedi", size: 12.0)
            coinShopDescription.textColor = UIColor.white
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        PVC.currentIndex = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkMoneyAchievement()
    {
        let money = UserDefaults.standard.integer(forKey: "moneySpent")
        
        var identifiers: [String] = []
        
        if money > 0
        {
            identifiers.append("spareChange")
        }
        
        if money > 10
        {
            identifiers.append("deepPockets")
        }
        
        if money > 20
        {
            identifiers.append("moneyTree")
        }
        
        reportAchievments(identifiers)
        
    }
    
    func reportAchievments(_ identifiers: [String])
    {
        var achievmentsToReport: [GKAchievement] = []
        
        for id in identifiers
        {
            let achievment = GKAchievement(identifier: id)
            
            achievment.percentComplete = 100.00
            
            achievmentsToReport.append(achievment)
        }
        
        GKAchievement.report(achievmentsToReport, withCompletionHandler: nil)
        
    }
    

    @IBAction func htCoins(_ sender: AnyObject) {
        
        let alert = UIAlertView(title: "Please Wait", message: nil, delegate: self, cancelButtonTitle: nil)
        
        alert.show()
        
        PFPurchase.buyProduct("htCoins", block: { (error) -> Void in
            
            alert.dismiss(withClickedButtonIndex: 0, animated: true)
            
            if error != nil
            {
                let errorAlert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                errorAlert.show()
            }
            else
            {
                let successAlert = UIAlertView(title: "Success", message: "Thank you for your purchase.", delegate: self, cancelButtonTitle: "Dismiss")
                
                successAlert.show()
                
                self.checkMoneyAchievement()
                
            }
            
        })
        
    }
   
    @IBAction func mCoins(_ sender: AnyObject) {
        
        let alert = UIAlertView(title: "Please Wait", message: nil, delegate: self, cancelButtonTitle: nil)
        
        alert.show()
        
        PFPurchase.buyProduct("mCoins", block: { (error) -> Void in
            
            alert.dismiss(withClickedButtonIndex: 0, animated: true)
            
            if error != nil
            {
                let errorAlert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                errorAlert.show()
            }
            else
            {
                let successAlert = UIAlertView(title: "Success", message: "Thank you for your purchase.", delegate: self, cancelButtonTitle: "Dismiss")
                
                successAlert.show()
                
                self.checkMoneyAchievement()
                
            }
            
        })
        
    }

    @IBAction func tmCoins(_ sender: AnyObject) {
        
        let alert = UIAlertView(title: "Please Wait", message: nil, delegate: self, cancelButtonTitle: nil)
        
        alert.show()
        
        PFPurchase.buyProduct("tmCoins", block: { (error) -> Void in
            
            alert.dismiss(withClickedButtonIndex: 0, animated: true)
            
            if error != nil
            {
                let errorAlert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                errorAlert.show()
            }
            else
            {
                let successAlert = UIAlertView(title: "Success", message: "Thank you for your purchase.", delegate: self, cancelButtonTitle: "Dismiss")
                
                successAlert.show()
                
                self.checkMoneyAchievement()
                
            }
            
        })
        
    }
    
    @IBAction func hmCoins(_ sender: AnyObject) {
        
        let alert = UIAlertView(title: "Please Wait", message: nil, delegate: self, cancelButtonTitle: nil)
        
        alert.show()
        
        PFPurchase.buyProduct("hmCoins", block: { (error) -> Void in
            
            alert.dismiss(withClickedButtonIndex: 0, animated: true)
            
            if error != nil
            {
                let errorAlert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                errorAlert.show()
            }
            else
            {
                let successAlert = UIAlertView(title: "Success", message: "Thank you for your purchase.", delegate: self, cancelButtonTitle: "Dismiss")
                
                successAlert.show()
                
                self.checkMoneyAchievement()
                
            }
            
        })
        
    }
    
}
