//
//  GameModeViewController.swift
//  Race
//
//  Created by Trevor Stevenson on 7/5/15.
//  Copyright (c) 2015 TStevensonApps. All rights reserved.
//

import UIKit
import GameKit

class GameModeViewController: UIViewController, GKMatchmakerViewControllerDelegate {

    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var onlineHeight: NSLayoutConstraint!
    @IBOutlet weak var trialsHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.view.frame.size.height == 480
        {
            bg.image = UIImage(named: "4S BG")
            
            onlineHeight.constant = 60
            trialsHeight.constant = 60
        }
        else if self.view.frame.size.width == 768
        {
            bg.image = UIImage(named: "Race BG iPad Main")
        }
        else if self.view.frame.size.height == 568
        {
            bg.image = UIImage(named: "A31 BG 5")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            for element in self.view.subviews
            {
                let eachView: UIView = element 
            
                eachView.alpha = 1.0
            }
            
        }) { (success) -> Void in }
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        for eachView in self.view.subviews
        {
            let element = eachView 

            element.alpha = 0.0
            
            if element.isKind(of: UIImageView.self)
            {
                element.alpha = 1.0
            }
        }
        
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        
        dismiss(animated: true, completion: nil)

    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
                
        dismiss(animated: true, completion: { () -> Void in
            
            self.presentGameWithGameModeAndMatch("Online", match: match)
            
        })
        
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func findMatch()
    {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let MMVC = GKMatchmakerViewController(matchRequest: request)
        MMVC!.matchmakerDelegate = self
        
        present(MMVC!, animated: true, completion: nil)
        
    }
    
    func presentGameWithGameModeAndMatch(_ mode: String, match: GKMatch?)
    {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            for element in self.view.subviews
            {
                let eachView: UIView = element 
                
                if element.isKind(of: UIImageView.self)
                {
                    eachView.alpha = 1.0
                    
                }
                else
                {
                    eachView.alpha = 0.0
                    
                }
                
            }
            
            }) { (success) -> Void in
                
                let GVC = self.storyboard?.instantiateViewController(withIdentifier: "GVC") as! GameViewController
                
                GVC.gameMode = mode
                
                if let gameMatch = match
                {
                    GVC.currentMatch = gameMatch
                    gameMatch.delegate = GVC
                }
                
                self.navigationController?.pushViewController(GVC, animated: false)

            }
    }
    
    // MARK: - Navigation
    
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
    
    @IBAction func playGame(_ sender: AnyObject) {
        
        let button = sender as! UIButton
        
        if button.titleLabel?.text == "online"
        {            
            findMatch()
        }
        else if button.titleLabel?.text == "Time Trials"
        {
            presentGameWithGameModeAndMatch("Time Trials", match: nil)
        }
        
        
    }

}
