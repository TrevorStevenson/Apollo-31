//
//  ShopViewController.swift
//  Race
//
//  Created by Trevor Stevenson on 7/3/15.
//  Copyright (c) 2015 TStevensonApps. All rights reserved.
//

import UIKit
import Parse

class ShopViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var currentIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PVC") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as! CoinShopViewController
        
        let viewControllers = NSArray(array: [startVC])
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
            
        })
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height - 50)
        
        self.addChildViewController(self.pageViewController)
        
        self.view.addSubview(self.pageViewController.view)
        
        self.pageViewController.didMove(toParentViewController: self)
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.darkGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.backgroundColor = UIColor.clear
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        for element in self.view.subviews
        {
            let eachView: UIView = element 
            
            if eachView.isKind(of: UIImageView.self)
            {
                eachView.alpha = 1.0
                
            }
            else
            {
                eachView.alpha = 0.0
                
            }
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            for element in self.view.subviews
            {
                let eachView: UIView = element 
                
                if eachView.isKind(of: UIImageView.self)
                {
                    eachView.alpha = 1.0
                    
                }
                else
                {
                    eachView.alpha = 1.0
                    
                }
                
            }
            
            }) { (success) -> Void in
                
        }
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController
    {
        
        if index == 0
        {
            let CSVC = self.storyboard?.instantiateViewController(withIdentifier: "CSVC") as! CoinShopViewController
            CSVC.pageIndex = index
            CSVC.PVC = self
            currentIndex = 0
            
            return CSVC
            
        }
        else if index == 1
        {
            
            let EVC = self.storyboard?.instantiateViewController(withIdentifier: "EVC") as! ExtraShopViewController
            EVC.pageIndex = index
            EVC.PVC = self
            currentIndex = 1
            
            return EVC
        }
        else
        {
            return CoinShopViewController()
        }
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index: Int = 0
        
        
        if currentIndex == 0
        {
            let VC = viewController as! CoinShopViewController
            index = VC.pageIndex as Int
            
        }
        if currentIndex == 1
        {
            let VC = viewController as! CoinShopViewController
            index = VC.pageIndex as Int
        }
        
        if index == 0 || index == NSNotFound
        {
            return nil
        }
        
        index -= 1
        
        return self.viewControllerAtIndex(index)
        
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        _ = viewController
        var index: Int = 0
        
        
        if currentIndex == 0
        {
            let VC = viewController as! CoinShopViewController
            index = VC.pageIndex as Int
            
        }
        if currentIndex == 1
        {
            let VC = viewController as! ExtraShopViewController
            index = VC.pageIndex as Int
        }
        
        if index == NSNotFound
        {
            return nil
        }
        
        index += 1
        
        if index == 2
        {
            return nil
        }
        
        
        return self.viewControllerAtIndex(index)
        
        
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return 2
        
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
        
    }

    
    @IBAction func back(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            for element in self.view.subviews
            {
                let eachView: UIView = element 
                
                if eachView.isKind(of: UIImageView.self)
                {
                    eachView.alpha = 1.0
                    
                }
                else
                {
                    eachView.alpha = 0.0
                    
                }
                
            }
            
            }) { (success) -> Void in
                
                let MVC = self.storyboard?.instantiateViewController(withIdentifier: "MVC") as! MainViewController
                
                self.navigationController?.pushViewController(MVC, animated: false)
                
        }

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
