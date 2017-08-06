//
//  SummaryViewController.swift
//  Race
//
//  Created by Trevor Stevenson on 7/5/15.
//  Copyright (c) 2015 TStevensonApps. All rights reserved.
//

import UIKit
import GameKit

class SummaryViewController: UIViewController {
    
    var summaryGameMode = ""
    var gameMinutes = 0
    var gameSeconds = 0
    var gameDecimal = 0
    var correct = 0
    var incorrect = 0
    var powerUps = 0
    var highScore = ""
    var isHighScore = false
    var didWin = false
    var didDraw = false
    var secret = 0
    
    
    @IBOutlet weak var gameModeLabel: UILabel!
    @IBOutlet weak var numberCorrectLabel: UILabel!
    @IBOutlet weak var numberIncorrectLabel: UILabel!
    @IBOutlet weak var powerUpsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var coinsEarnedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var identifiers: [String] = []
        
        let wins = UserDefaults.standard.integer(forKey: "wins")
        let losses = UserDefaults.standard.integer(forKey: "losses")
        let draws = UserDefaults.standard.integer(forKey: "draws")
        var powerUpsUsed = UserDefaults.standard.integer(forKey: "powerUpsUsed")
        
        if summaryGameMode == "Online"
        {
            timeLabel.isHidden = true
            highScoreLabel.isHidden = true
            
            if didWin
            {
                gameModeLabel.text = "You Won!"
            }
            else
            {
                if didDraw
                {
                    if secret == 317
                    {
                        gameModeLabel.text = "Game disconnected from opponent."
                    }
                    
                    gameModeLabel.text = "You Tied!"
                }
                else
                {
                    gameModeLabel.text = "You Lost!"
                }
            }

            reportScore(Int64(wins), leaderboardID: "onlineWins")
        }
        
        if summaryGameMode == "Time Trials"
        {
            recordLabel.isHidden = true
            gameModeLabel.text = "Game Mode: Time Trials"
            
            let score = ((gameMinutes * 60 + gameSeconds) * 100) + gameDecimal
            
            reportScore(Int64(score), leaderboardID: "timeTrials2")
            reportScore(Int64(score), leaderboardID: "timeTrials")
            
        }
        
        powerUpsUsed += powerUps
        
        UserDefaults.standard.set(powerUpsUsed, forKey: "powerUpsUsed")
        
        reportScore(Int64(powerUpsUsed), leaderboardID: "powerUps")
        
        numberCorrectLabel.text = "Number Correct: \(correct)"
        numberIncorrectLabel.text = "Number incorrect: \(incorrect)"
        powerUpsLabel.text = "Power ups used: \(powerUps)"
        highScoreLabel.text = highScore
        recordLabel.text = "Record: \(wins)-\(losses)-\(draws)"
        
        var secString = ""
        var decString = ""
        
        if gameSeconds < 10
        {
            secString = "0\(gameSeconds)"
        }
        else
        {
            secString = "\(gameSeconds)"
        }
        
        if gameDecimal < 10
        {
            decString = "0\(gameDecimal)"
        }
        else
        {
            decString = "\(gameDecimal)"

        }
        
        timeLabel.text = "Time: \(gameMinutes):" + secString + ":" + decString
        
        
        if incorrect == 0
        {
            identifiers.append("flawless")
        }
        
        if (incorrect == 0 && isHighScore) || (incorrect == 0 && didWin)
        {
            identifiers.append("flawlessUP")
        }
        
        if (didWin) && (wins == 1)
        {
            identifiers.append("firstWin")
        }
        
        if (didWin) && (wins == 10)
        {
            identifiers.append("tenWins")
        }
        
        if (didWin) && (wins == 100)
        {
            identifiers.append("hundredWins")
        }
        
        if (didWin) && (wins == 1)
        {
            identifiers.append("thousandWins")
        }
        
        let totalSeconds = (gameMinutes * 60) + gameSeconds
        
        if totalSeconds < 60
        {
            identifiers.append("sub60")
        }
        
        if (didWin) && (powerUps == 0)
        {
            identifiers.append("onMyOwn")
        }
        
        if powerUpsUsed >= 10
        {
            identifiers.append("powerUpNovice")
        }
        
        if powerUpsUsed >= 100
        {
            identifiers.append("powerUpMaster")
        }
        
        if powerUpsUsed >= 1000
        {
            identifiers.append("powerUpKing")
        }
        
        reportAchievments(identifiers)
        
        var coinsEarned = 1000
        
        if didWin
        {
            coinsEarned += 4000
        }
        
        
        if isHighScore
        {
            coinsEarned += 1000
        }
        
        var coins = UserDefaults.standard.integer(forKey: "coins")
        
        coins += coinsEarned
        
        UserDefaults.standard.set(coins, forKey: "coins")
        
        UserDefaults.standard.synchronize()
        
        coinsEarnedLabel.text = "Coins Earned: \(coinsEarned)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func reportScore(_ score: Int64, leaderboardID: String)
    {
        let scoreToReport = GKScore(leaderboardIdentifier: leaderboardID)
        
        scoreToReport.value = score
        
        GKScore.report([scoreToReport], withCompletionHandler: nil)
        
    }
    
    
    
    @IBAction func quit(_ sender: AnyObject) {
        
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

    

}
