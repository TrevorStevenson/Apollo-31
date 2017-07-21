//
//  TutorialViewController.swift
//  Race
//
//  Created by Trevor Stevenson on 7/3/15.
//  Copyright (c) 2015 TStevensonApps. All rights reserved.
//

import UIKit
import Social
import MediaPlayer
import GameKit

class TutorialViewController: UIViewController {
    
    var moviePlayer: MPMoviePlayerViewController?
    var rotate = false
    
    @IBOutlet weak var bg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return [UIInterfaceOrientationMask.landscape, UIInterfaceOrientationMask.portrait]
    }
    
    override var shouldAutorotate : Bool {
        
        return true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            for element in self.view.subviews
            {
                let eachView: UIView = element 
                
                eachView.alpha = 1.0
            }
            
            
            
            }) { (success) -> Void in
                
                
                
        }
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateOut(_ toViewController: UIViewController)
    {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
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
                
                self.navigationController?.pushViewController(toViewController, animated: false)
                
        }
        
        
        
    }

    
    @IBAction func dismiss(_ sender: AnyObject) {
        
        let MVC = self.storyboard?.instantiateViewController(withIdentifier: "MVC") as! MainViewController
        
        animateOut(MVC)
        
    }
    
    @IBAction func follow(_ sender: AnyObject) {
        
        let twitterURL = URL(string: "twitter://user?screen_name=tstevensonapps")
        
        if (UIApplication.shared.canOpenURL(twitterURL!))
        {
            UIApplication.shared.openURL(twitterURL!)
        }
        else
        {
            UIApplication.shared.openURL(URL(fileURLWithPath: "www.twitter.com/tstevensonapps"))
        }
        
        reportAchievments(["LOTP"])

    }

    @IBAction func tweet(_ sender: AnyObject) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
        {
            let tweet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            tweet?.setInitialText("Play me in Apollo 31! @tstevensonapps")
            
            tweet?.add(URL(string: "http://www.itunes.com/apps/trevorstevenson"))
            
            self.present(tweet!, animated: true, completion: nil)
            
            reportAchievments(["LOTP"])

        }
        else
        {
            let alert = UIAlertView(title: "Twitter", message: "There must be a Twitter account set up on this device to tweet.", delegate: self, cancelButtonTitle: "Ok")
            
            alert.show()
            
        }

    }
    
    @IBAction func share(_ sender: AnyObject) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)
        {
            let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            post?.setInitialText("Play me in Apollo 31!")
            
            post?.add(URL(string: "http://www.itunes.com/apps/trevorstevenson"))
            
            self.present(post!, animated: true, completion: nil)
            
            reportAchievments(["LOTP"])

        }
        else
        {
            let alert = UIAlertView(title: "Facebook", message: "There must be a Facebook account set up on this device to share.", delegate: self, cancelButtonTitle: "Ok")
            
            alert.show()
            
        }

    }
    
    @IBAction func like(_ sender: AnyObject) {
        
        let fbURL = URL(string: "fb://profile/tstevensonapps")
        
        if (UIApplication.shared.canOpenURL(fbURL!))
        {
            UIApplication.shared.openURL(fbURL!)
        }
        else
        {
            UIApplication.shared.openURL(URL(fileURLWithPath: "www.facebook.com/tstevensonapps"))
        }
        
        reportAchievments(["LOTP"])
        
    }
    
    func playVideo() {
        
        let path = Bundle.main.path(forResource: "Tutorial", ofType:"mp4")
        let url = URL(fileURLWithPath: path!)
        
        moviePlayer = MPMoviePlayerViewController(contentURL: url)
        
        if let player = moviePlayer {
            
            player.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            player.view.sizeToFit()
            player.moviePlayer.scalingMode = MPMovieScalingMode.fill
            player.moviePlayer.isFullscreen = true
            player.moviePlayer.controlStyle = MPMovieControlStyle.none
            player.moviePlayer.movieSourceType = MPMovieSourceType.file
            player.moviePlayer.repeatMode = MPMovieRepeatMode.none
            
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            self.show(player, sender: self)
            player.view.layer.setAffineTransform(CGAffineTransform(rotationAngle: .pi/2.0))
            
            player.moviePlayer.play()
            
            NotificationCenter.default.addObserver(self, selector: #selector(TutorialViewController.playerDidFinish), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: nil)
            
        }
        
    }
    
    func playerDidFinish()
    {
        print("finish")
        
        let MVC = self.storyboard?.instantiateViewController(withIdentifier: "MVC") as! MainViewController
        
        animateOut(MVC)
       
    }
    
    @IBAction func playTutorial(_ sender: AnyObject) {
        
        playVideo()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
