//
//  MainViewController.swift
//  Race
//
//  Created by Trevor Stevenson on 7/3/15.
//  Copyright (c) 2015 TStevensonApps. All rights reserved.
//

import UIKit
import GameKit

class MainViewController: UIViewController, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKLocalPlayerListener {
    
    //subviews
    var titleLabel = UILabel()
    var playButton = UIButton()
    var leaderboardButton = UIButton()
    var shopButton = UIButton()

    //outlets
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var bg: UIImageView!
    
    //variables
    var didLayoutSubviews = false
    var gameCenterEnabled = false
    var leaderboardIdentifier = "Wins"
    
    //constraints
    @IBOutlet weak var recordConstraint: NSLayoutConstraint!
    @IBOutlet weak var helpConstraint: NSLayoutConstraint!
    @IBOutlet weak var coinsConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        
        if self.view.frame.size.height == 480
        {
            bg.image = UIImage(named: "4S BG")
        }
        else if self.view.frame.size.width == 768
        {
            bg.image = UIImage(named: "Race BG iPad Main")
        }
        else if self.view.frame.size.height == 568.0
        {
            bg.image = UIImage(named: "A31 BG 5")
        }
        
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        authenticateLocalPlayer()
        
        let wins = UserDefaults.standard.integer(forKey: "wins")
        
        let losses = UserDefaults.standard.integer(forKey: "losses")
        
        let draws = UserDefaults.standard.integer(forKey: "draws")
        
        let coins = UserDefaults.standard.integer(forKey: "coins")
        
        recordLabel.text = "\(wins)-\(losses)-\(draws)"
        
        coinsLabel.text = "Coins: \(coins)"
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        animateIn()

    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        if !didLayoutSubviews
        {
            
            let viewSize = self.view.frame.size
            
            recordConstraint.constant = 8 - viewSize.height
            helpConstraint.constant = 8 - viewSize.height
            coinsConstraint.constant = 8 - viewSize.height
            
            var buttonHeight: CGFloat = 80
            var separation: CGFloat = 10
            var fontSize: CGFloat = 50
            
            if self.view.frame.size.height == 480
            {
                buttonHeight = 60
                separation = 5
                fontSize = 40
            }
            else if self.view.frame.size.height == 568
            {
                buttonHeight = 70
                separation = 5
                fontSize = 45
            }

            titleLabel = UILabel(frame: CGRect(x: 20, y: viewSize.height/6 - viewSize.height, width: viewSize.width - 40, height: 50))
            titleLabel.text = "Apollo 31"
            titleLabel.font = UIFont(name: "Star Jedi", size: fontSize)
            titleLabel.textColor = UIColor.white
            titleLabel.textAlignment = NSTextAlignment.center
            
            self.view.addSubview(titleLabel)
            
            playButton = UIButton(frame: CGRect(x: 0, y: (3 * viewSize.height)/(2) - (3 * buttonHeight)/(2) - separation, width: viewSize.width, height: buttonHeight))
            playButton.addTarget(self, action: #selector(MainViewController.play), for: .touchUpInside)
            playButton.setTitle("Play", for: UIControlState())
            playButton.titleLabel?.font = UIFont(name: "Star Jedi", size: 25)
            playButton.setTitleColor(UIColor.white, for: UIControlState())
            playButton.setBackgroundImage(UIImage(named: "Race Button"), for: UIControlState())
            
            self.view.addSubview(playButton)
            
            leaderboardButton = UIButton(frame: CGRect(x: 0, y: (3 * viewSize.height)/(2) - buttonHeight/2, width: viewSize.width, height: buttonHeight))
            leaderboardButton.addTarget(self, action: #selector(MainViewController.leaderboard), for: .touchUpInside)
            leaderboardButton.setTitle("Leaderboard", for: UIControlState())
            leaderboardButton.titleLabel?.font = UIFont(name: "Star Jedi", size: 25)
            leaderboardButton.setTitleColor(UIColor.white, for: UIControlState())
            leaderboardButton.setBackgroundImage(UIImage(named: "Race Button"), for: UIControlState())
            
            self.view.addSubview(leaderboardButton)
            
            shopButton = UIButton(frame: CGRect(x: 0, y: (3 * viewSize.height)/(2) + buttonHeight/2 + separation, width: viewSize.width, height: buttonHeight))
            shopButton.addTarget(self, action: #selector(MainViewController.shop), for: .touchUpInside)
            shopButton.setTitle("Shop", for: UIControlState())
            shopButton.titleLabel?.font = UIFont(name: "Star Jedi", size: 25)
            shopButton.setTitleColor(UIColor.white, for: UIControlState())
            shopButton.setBackgroundImage(UIImage(named: "Race Button"), for: UIControlState())

            self.view.addSubview(shopButton)
            
            didLayoutSubviews = true

        }
        
        
    }

    func authenticateLocalPlayer()
    {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = { (viewController: UIViewController?, error: NSError?) -> Void in
            
            if viewController != nil
            {
                self.present(viewController!, animated: true, completion: nil)
            }
            else if localPlayer.isAuthenticated
            {
                self.gameCenterEnabled = true
                /*
                GKNotificationBanner.showBannerWithTitle("Welcome \(localPlayer.alias)", message: nil, completionHandler: { () -> Void in
                    
                })
                */
                localPlayer.register(self)
                
                GKLocalPlayer.localPlayer().loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier:String?, error:NSError?) -> Void in
                    
                    if (error != nil)
                    {
                        print(error!.localizedDescription)
                    }
                    else
                    {
                        self.leaderboardIdentifier = leaderboardIdentifier!
                        
                       
                    }
                    
                } as! (String?, Error?) -> Void)

            }
            else
            {
                self.gameCenterEnabled = false
            }
            
        } as! (UIViewController?, Error?) -> Void
        
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        
        dismiss(animated: true, completion: { () -> Void in
            
            self.presentGameWithGameModeAndMatch("Online", match: match)
            
        })
    }
    
    func presentGameWithGameModeAndMatch(_ mode: String, match: GKMatch)
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
                GVC.currentMatch = match
                match.delegate = GVC
                
                self.navigationController?.pushViewController(GVC, animated: false)
                
        }
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        
        let MMVC = GKMatchmakerViewController(invite: invite)
        MMVC!.matchmakerDelegate = self
        
        present(MMVC!, animated: true, completion: nil)
        
    }
    
    func animateIn()
    {
        UIView.animate(withDuration: 1.25, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            self.titleLabel.center.y += (self.view.frame.size.height + 10)
            self.recordLabel.center.y += (self.view.frame.size.height + 10)
            self.coinsLabel.center.y += (self.view.frame.size.height + 10)


            self.playButton.center.y -= (self.view.frame.size.height + 10)
            self.leaderboardButton.center.y -= (self.view.frame.size.height + 10)
            self.shopButton.center.y -= (self.view.frame.size.height + 10)
            self.helpButton.center.y -= (self.view.frame.size.height + 10)

            
            
            }) { (success) -> Void in
                
                UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                    
                    self.titleLabel.center.y -= 10
                    self.recordLabel.center.y -= 10
                    self.coinsLabel.center.y -= 10
                    
                    self.playButton.center.y += 10
                    self.leaderboardButton.center.y += 10
                    self.shopButton.center.y += 10
                    self.helpButton.center.y += 10
                    
                    }, completion: { (success) -> Void in
                        
                        
                })

        }

    }
    
    func animateOut(_ toViewController: UIViewController)
    {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            self.titleLabel.center.y += 10
            self.recordLabel.center.y += 10
            self.coinsLabel.center.y += 10

            self.playButton.center.y -= 10
            self.leaderboardButton.center.y -= 10
            self.shopButton.center.y -= 10
            self.helpButton.center.y -= 10
            
            }) { (success) -> Void in
                
                UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                    
                    self.titleLabel.center.y -= (self.view.frame.size.height + 10)
                    self.recordLabel.center.y -= (self.view.frame.size.height + 10)
                    self.coinsLabel.center.y -= (self.view.frame.size.height + 10)
                    
                    self.playButton.center.y += (self.view.frame.size.height + 10)
                    self.leaderboardButton.center.y += (self.view.frame.size.height + 10)
                    self.shopButton.center.y += (self.view.frame.size.height + 10)
                    self.helpButton.center.y += (self.view.frame.size.height + 10)

                    
                    
                    }, completion: { (success) -> Void in
                        
                        self.navigationController?.pushViewController(toViewController, animated: false)
                        
                })
                
        }



    }
    
    func play() {
        
        let GMVC = storyboard?.instantiateViewController(withIdentifier: "GMVC") as! GameModeViewController
        
        animateOut(GMVC)
        
    }

    func leaderboard() {
        
        let GCVC = GKGameCenterViewController()
        
        GCVC.gameCenterDelegate = self
        
        GCVC.viewState = GKGameCenterViewControllerState.leaderboards
        
        GCVC.leaderboardIdentifier = "onlineWins"
        
        present(GCVC, animated: true, completion: nil)
        
        
        
    }
   
    func shop() {
        
        let SVC = storyboard?.instantiateViewController(withIdentifier: "SVC") as! ShopViewController
        
        animateOut(SVC)
    }
    
    @IBAction func help(_ sender: AnyObject) {
        
        let TVC = storyboard?.instantiateViewController(withIdentifier: "TVC") as! TutorialViewController
        
        animateOut(TVC)
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        didLayoutSubviews = true
    }
    

}
