//
//  PauseMenu.swift
//  Race
//
//  Created by Trevor Stevenson on 7/5/15.
//  Copyright (c) 2015 TStevensonApps. All rights reserved.
//

import UIKit

class PauseMenu: UIView {

    var pauseGameMode = ""
    var parent = GameViewController()
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        bg.image = UIImage(named: "Pause Menu")
        
        self.addSubview(bg)
        
        if pauseGameMode == "Online"
        {
            let resumeButton = UIButton(frame: CGRect(x: 10, y: 33, width: self.frame.size.width - 20, height: 35))
            resumeButton.addTarget(self, action: #selector(PauseMenu.resume), for: UIControlEvents.touchUpInside)
            resumeButton.setTitle("Resume", for: UIControlState())
            resumeButton.setBackgroundImage(UIImage(named: "Race Button"), for: UIControlState())
            resumeButton.titleLabel?.font = UIFont(name: "Star Jedi", size: 18)
            
            self.addSubview(resumeButton)
            
            let quitButton = UIButton(frame: CGRect(x: 10, y: 82, width: self.frame.size.width - 20, height: 35))
            quitButton.addTarget(self, action: #selector(PauseMenu.quit), for: UIControlEvents.touchUpInside)
            quitButton.setTitle("Forfeit", for: UIControlState())
            quitButton.setBackgroundImage(UIImage(named: "Race Button"), for: UIControlState())
            quitButton.titleLabel?.font = UIFont(name: "Star Jedi", size: 18)
            
            self.addSubview(quitButton)


        }
        if pauseGameMode == "Time Trials"
        {
            
            let resumeButton = UIButton(frame: CGRect(x: 10, y: 18, width: self.frame.size.width - 20, height: 35))
            resumeButton.addTarget(self, action: #selector(PauseMenu.resume), for: UIControlEvents.touchUpInside)
            resumeButton.setTitle("Resume", for: UIControlState())
            resumeButton.setBackgroundImage(UIImage(named: "Race Button"), for: UIControlState())
            resumeButton.titleLabel?.font = UIFont(name: "Star Jedi", size: 18)
            
            self.addSubview(resumeButton)
            
            let restartButton = UIButton(frame: CGRect(x: 10, y: 57, width: self.frame.size.width - 20, height: 35))
            restartButton.addTarget(self, action: #selector(PauseMenu.restart), for: UIControlEvents.touchUpInside)
            restartButton.setTitle("Restart", for: UIControlState())
            restartButton.setBackgroundImage(UIImage(named: "Race Button"), for: UIControlState())
            restartButton.titleLabel?.font = UIFont(name: "Star Jedi", size: 18)
            
            self.addSubview(restartButton)
            
            let quitButton = UIButton(frame: CGRect(x: 10, y: 97, width: self.frame.size.width - 20, height: 35))
            quitButton.addTarget(self, action: #selector(PauseMenu.quit), for: UIControlEvents.touchUpInside)
            quitButton.setTitle("quit", for: UIControlState())
            quitButton.setBackgroundImage(UIImage(named: "Race Button"), for: UIControlState())
            quitButton.titleLabel?.font = UIFont(name: "Star Jedi", size: 18)
            
            self.addSubview(quitButton)
            
            
            
        }
        
        
    }
    
    func restart()
    {
        parent.restartGame()
    }
    
    func quit()
    {
        if pauseGameMode == "Online"
        {
            var losses = UserDefaults.standard.integer(forKey: "losses")
            
            losses += 1
            
            UserDefaults.standard.set(losses, forKey: "losses")
            
            UserDefaults.standard.synchronize()
        }
        
        parent.quitGame()
    }
    
    func resume()
    {
        parent.resumeGame()
    }
    

}
