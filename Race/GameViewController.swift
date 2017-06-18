//
//  GameViewController.swift
//  Race
//
//  Created by Trevor Stevenson on 7/3/15.
//  Copyright (c) 2015 TStevensonApps. All rights reserved.
//

import UIKit
import QuartzCore
import GameKit

class GameViewController: UIViewController, GKMatchDelegate, UIAlertViewDelegate {

    
    //outlets
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var powerUp1Label: UILabel!
    @IBOutlet weak var powerUp2Label: UILabel!
    @IBOutlet weak var powerUp3Label: UILabel!
    @IBOutlet weak var powerUp4Label: UILabel!
    @IBOutlet weak var powerUpOne: UIButton!
    @IBOutlet weak var powerUpTwo: UIButton!
    @IBOutlet weak var powerUpThree: UIButton!
    @IBOutlet weak var powerUpFour: UIButton!
    @IBOutlet weak var coinsLabel: UILabel!
    
    //constraints
    
    @IBOutlet weak var leftHorizontalSpace: NSLayoutConstraint!
    @IBOutlet weak var rightHorizontalSpace: NSLayoutConstraint!
    @IBOutlet weak var barHeight: NSLayoutConstraint!
    
    //gesture outlets
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet var swipeUp: UISwipeGestureRecognizer!
    @IBOutlet var swipeRight: UISwipeGestureRecognizer!
    @IBOutlet var swipeDown: UISwipeGestureRecognizer!
    @IBOutlet var swipeLeft: UISwipeGestureRecognizer!
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    //countdown variables
    var countdownNumber = 5
    var countdownLabel = UILabel()
    var countdownTimer = Timer()
    
    //game variables
    var randomInteger = 4
    var swipeCode = 0
    var isGameReady = false
    var gameTimer = Timer()
    var timerMinutes = 5
    var timerSeconds = 0
    var timerDecimal = 0
    var gameMode = ""
    var numberCorrect = 0
    var numberIncorrect = 0
    var hasCountdownEnded = false
    var isPaused = false
    var pauseMenu: PauseMenu!
    var shouldLayout = true
    var currentProgress = 0
    var matchStarted = false
    var currentMatch: GKMatch?
    var opponentAlias = ""
    var amountToProgress: Float = 0.01
    var currentCoins = 0
    
    
    //power up variables
    var canUsePowerUps = true
    var hasPenalty = true
    var powerUpsUsed = 0
    var powerUp1Timer = Timer()
    var powerUp2Timer = Timer()
    var powerUp3Timer = Timer()
    var powerUp4Timer = Timer()
    var powerUp1Countdown = 30
    var powerUp2Countdown = 30
    var powerUp3Countdown = 30
    var powerUp4Countdown = 30
    var zapLabel = UILabel()
    var zap10 = 10
    var zapUpdateTimer = Timer()
    var clearTimer = Timer()
    var multiplyTimer = Timer()
    var multiply10 = 10
    var defenseTimer = Timer()
    var defense30 = 30


    
    //view controller life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        progressBar.progress = 0.0
        
        progressLabel.text = "\(Int(progressBar.progress * 100))/100"
        
        correctLabel.text = ""
        instructionLabel.text = ""
        
        pauseButton.isEnabled = false
        powerUpOne.isEnabled = false
        powerUpTwo.isEnabled = false
        powerUpThree.isEnabled = false
        powerUpFour.isEnabled = false
        
        
        currentCoins = UserDefaults.standard.integer(forKey: "coins")
        
        coinsLabel.text = "Coins: \(currentCoins)"
        
        if gameMode == "Time Trials"
        {
            timerMinutes = 0
            clockLabel.text = "0:00.00"
            
            let userDefaults = UserDefaults.standard
            
            let minutes = userDefaults.integer(forKey: "highScoreMinutes")
            let seconds = userDefaults.integer(forKey: "highScoreSeconds")
            let decimal = userDefaults.integer(forKey: "highScoreDecimal")
            
            var middleString = ""
            var rightString = ""
            
            if seconds < 10
            {
                middleString = "0\(seconds)"
            }
            else
            {
                middleString = "\(seconds)"
            }
            if decimal < 10
            {
                rightString = "0\(decimal)"
            }
            else
            {
                rightString = "\(decimal)"
            }
            
            opponentLabel.text = "High Score: \(minutes):" + middleString + ":" + rightString
            
            self.countdownLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2 - 75, width: 150, height: 150))
            self.countdownLabel.text = String(self.countdownNumber)
            self.countdownLabel.font = UIFont(name: "Star Jedi", size: 50)
            self.countdownLabel.adjustsFontSizeToFitWidth = true
            self.countdownLabel.textAlignment = .center
            self.countdownLabel.textColor = UIColor.white
            
            self.view.addSubview(self.countdownLabel)
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.5
            scaleAnimation.duration = 0.25
            scaleAnimation.repeatCount = 1
            scaleAnimation.autoreverses = true
            self.countdownLabel.layer.add(scaleAnimation, forKey: nil)
            
            
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.countdown), userInfo: nil, repeats: true)
            
        }
        else if gameMode == "Online"
        {
            clockLabel.text = "5:00"
            
            let opponent = currentMatch!.players[0] 
            
            self.opponentAlias = opponent.alias!
            
            opponentLabel.text = "\(self.opponentAlias): 0/100"
            
            if !self.matchStarted && currentMatch!.expectedPlayerCount == 0
            {
                self.countdownLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2 - 75, width: 150, height: 150))
                self.countdownLabel.text = String(self.countdownNumber)
                self.countdownLabel.font = UIFont(name: "Star Jedi", size: 50)
                self.countdownLabel.adjustsFontSizeToFitWidth = true
                self.countdownLabel.textAlignment = .center
                self.countdownLabel.textColor = UIColor.white
                
                self.view.addSubview(self.countdownLabel)
                
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = 1.0
                scaleAnimation.toValue = 1.5
                scaleAnimation.duration = 0.25
                scaleAnimation.repeatCount = 1
                scaleAnimation.autoreverses = true
                self.countdownLabel.layer.add(scaleAnimation, forKey: nil)
                
                
                self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.countdown), userInfo: nil, repeats: true)
                
                self.matchStarted = true
                
            }
        }
        
        
        isGameReady = false
        
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        tapGesture.addTarget(self, action: #selector(GameViewController.checkRecognizer(_:)))
        pinchGesture.addTarget(self, action: #selector(GameViewController.checkRecognizer(_:)))
        swipeUp.addTarget(self, action: #selector(GameViewController.checkRecognizer(_:)))
        swipeRight.addTarget(self, action: #selector(GameViewController.checkRecognizer(_:)))
        swipeDown.addTarget(self, action: #selector(GameViewController.checkRecognizer(_:)))
        swipeLeft.addTarget(self, action: #selector(GameViewController.checkRecognizer(_:)))
        longPressGesture.addTarget(self, action: #selector(GameViewController.checkRecognizer(_:)))

    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        if shouldLayout
        {
            leftHorizontalSpace.constant = ((self.view.frame.size.width - 82) / 3) - 50
            rightHorizontalSpace.constant = ((self.view.frame.size.width - 82) / 3) - 50
            barHeight.constant = 10
            
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
            
            shouldLayout = false
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            print("anim")
            
            for element in self.view.subviews
            {
                let eachView: UIView = element 
                
                eachView.alpha = 1.0
                
            }
            
        }) { (success) -> Void in
            
            
        }
    }
    
    //match delegate
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        
        switch state
        {
            
        case GKPlayerConnectionState.stateConnected:
            
            currentMatch = match
            
            break
            
        case GKPlayerConnectionState.stateDisconnected:
            
            if matchStarted == true
            {
                if currentMatch != nil
                {
                    self.matchStarted = false
                    
                    gameTimer.invalidate()
                    isGameReady = false
                    view.isUserInteractionEnabled = false
                    
                    let summary = storyboard?.instantiateViewController(withIdentifier: "Summary") as! SummaryViewController
                    
                    summary.summaryGameMode = gameMode
                    summary.correct = numberCorrect
                    summary.incorrect = numberIncorrect
                    summary.didDraw = true
                    summary.didWin = false
                    summary.secret = 317
                    
                    currentMatch!.disconnect()
                    
                    currentMatch = nil
                    
                    UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                        
                        for element in self.view.subviews
                        {
                            let eachView: UIView = element 
                            
                            if eachView.isKind(of: UIImageView.self)
                            {
                                if eachView.tag == 1
                                {
                                    eachView.alpha = 0.0
                                    
                                }
                                else
                                {
                                    eachView.alpha = 1.0
                                    
                                }
                                
                            }
                            else
                            {
                                eachView.alpha = 0.0
                                
                            }
                            
                        }
                        
                        }) { (success) -> Void in
                            
                            self.navigationController?.pushViewController(summary, animated: false)
                            
                    }
                }
            }
            
            break
            
        default:
            
            //do nothing
            
            break
            
            
        }
        
        
    }
    
    func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
        
        return false
    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        
        
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        let dataType = unarchiver.decodeInt32(forKey: "dataType")
        
        if dataType == 0
        {
            let opponentProgress = unarchiver.decodeInt32(forKey: "currentProgress")
            
            opponentLabel.text = "\(opponentAlias): \(opponentProgress)/100"

        }
        else if dataType == 1
        {
            loss()
        }
        else if dataType == 2
        {
            
            isGameReady = false
            self.view.isUserInteractionEnabled = false
            
            instructionLabel.text = "You've been zapped!"
            instructionLabel.textColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1.0)
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.5
            scaleAnimation.duration = 0.25
            scaleAnimation.repeatCount = 1
            scaleAnimation.autoreverses = true
            instructionLabel.layer.add(scaleAnimation, forKey: nil)
            
            _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(GameViewController.zapCountdown), userInfo: nil, repeats: false)
            
            
        }
        else if dataType == 3
        {
            activityLabel.text = "\(opponentAlias) used the boost power up!"
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.1
            scaleAnimation.duration = 0.25
            scaleAnimation.repeatCount = 1
            scaleAnimation.autoreverses = true
            activityLabel.layer.add(scaleAnimation, forKey: nil)
            
        }
        else if dataType == 4
        {
            activityLabel.text = "\(opponentAlias) used the multiplier power up!"
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.1
            scaleAnimation.duration = 0.25
            scaleAnimation.repeatCount = 1
            scaleAnimation.autoreverses = true
            activityLabel.layer.add(scaleAnimation, forKey: nil)
            
        }
        else if dataType == 5
        {
            activityLabel.text = "\(opponentAlias) used the defense power up!"
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.1
            scaleAnimation.duration = 0.25
            scaleAnimation.repeatCount = 1
            scaleAnimation.autoreverses = true
            activityLabel.layer.add(scaleAnimation, forKey: nil)
            
            canUsePowerUps = false
        }
        
        unarchiver.finishDecoding()
        
        
    }
    
    func sendData(_ dataType: String)
    {
        if dataType == "Progress"
        {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            
            if currentProgress < 0
            {
                archiver.encode(0, forKey: "currentProgress")
            }
            else
            {
                archiver.encode(Int32(currentProgress), forKey: "currentProgress")
            }
            
            archiver.encode(0, forKey: "dataType")
            archiver.finishEncoding()
        
            do {
                try currentMatch!.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.unreliable)
            } catch let error1 as NSError {
                error = error1
            }
        }
        else if dataType == "Victory"
        {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.encode(1, forKey: "dataType")
            archiver.finishEncoding()
            
            do {
                try currentMatch!.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.unreliable)
            } catch let error1 as NSError {
                error = error1
            }
        }
        else if dataType == "Power Up 1"
        {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.encode(2, forKey: "dataType")
            archiver.finishEncoding()
            
            do {
                try currentMatch!.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.unreliable)
            } catch let error1 as NSError {
                error = error1
            }

        }
        else if dataType == "Power Up 2"
        {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.encode(3, forKey: "dataType")
            archiver.finishEncoding()
            
            do {
                try currentMatch!.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.unreliable)
            } catch let error1 as NSError {
                error = error1
            }
            
        }
        else if dataType == "Power Up 3"
        {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.encode(4, forKey: "dataType")
            archiver.finishEncoding()
            
            do {
                try currentMatch!.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.unreliable)
            } catch let error1 as NSError {
                error = error1
            }
            
        }
        else if dataType == "Power Up 4"
        {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.encode(5, forKey: "dataType")
            archiver.finishEncoding()
            
            do {
                try currentMatch!.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.unreliable)
            } catch let error1 as NSError {
                error = error1
            }
        }
    
    }
    
    //game functions
  
    func countdown() {
        
        countdownNumber -= 1
        
        if countdownNumber <= 0
        {
            countdownLabel.text = "Begin!"
            
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameViewController.removeCountdown), userInfo: nil, repeats: false)
            
            countdownTimer.invalidate()
            
        }
        else
        {
            countdownLabel.text = String(countdownNumber)

        }
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.5
        scaleAnimation.duration = 0.25
        scaleAnimation.repeatCount = 1
        scaleAnimation.autoreverses = true
        countdownLabel.layer.add(scaleAnimation, forKey: nil)
        
    }
    
    func removeCountdown () {
        
        if gameMode == "Online"
        {
             gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.gameCountdown), userInfo: nil, repeats: true)
        }
        else if gameMode == "Time Trials"
        {
             gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameViewController.gameCountdown), userInfo: nil, repeats: true)
        }
        
        countdownLabel.removeFromSuperview()
        
        isGameReady = true
        pauseButton.isEnabled = true
        checkCoinLevels()
        hasCountdownEnded = true
        
        createInstruction()
        
    }
    
    func gameCountdown()
    {
        
        if gameMode == "Online"
        {
            if timerSeconds == 0
            {
                
                if timerMinutes == 0
                {
                    //game over
                    
                    self.matchStarted = false
                    
                    gameTimer.invalidate()
                    isGameReady = false
                    view.isUserInteractionEnabled = false
                    
                    let summary = storyboard?.instantiateViewController(withIdentifier: "Summary") as! SummaryViewController
                    
                    summary.summaryGameMode = gameMode
                    summary.correct = numberCorrect
                    summary.incorrect = numberIncorrect
                    summary.didDraw = true
                    summary.didWin = false
                    
                    var draws = UserDefaults.standard.integer(forKey: "draws")
                    
                    draws += 1
                    
                    UserDefaults.standard.set(draws, forKey: "draws")
                    
                    UserDefaults.standard.synchronize()
                    
                    currentMatch!.disconnect()
                    
                    currentMatch = nil
                    
                    UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                        
                        for element in self.view.subviews
                        {
                            let eachView: UIView = element 
                            
                            if eachView.isKind(of: UIImageView.self)
                            {
                                if eachView.tag == 1
                                {
                                    eachView.alpha = 0.0
                                    
                                }
                                else
                                {
                                    eachView.alpha = 1.0
                                    
                                }
                                
                            }
                            else
                            {
                                eachView.alpha = 0.0
                                
                            }
                            
                        }
                        
                        }) { (success) -> Void in
                            
                            self.navigationController?.pushViewController(summary, animated: false)
                            
                    }

                    
                }
                else
                {
                    timerSeconds = 59
                    timerMinutes -= 1
                }
                
            }
            else
            {
                timerSeconds -= 1
            }
            
            if timerSeconds < 10
            {
                clockLabel.text = "\(timerMinutes):0\(timerSeconds)"
            }
            else
            {
                clockLabel.text = "\(timerMinutes):\(timerSeconds)"
                
            }
        }
        else if gameMode == "Time Trials"
        {
            timerDecimal += 1
            
            if timerDecimal == 100
            {
                timerDecimal = 0
                timerSeconds += 1
                
                if timerSeconds == 60
                {
                    timerSeconds = 0
                    timerMinutes += 1
                }
            }
            
            var secondsString = ""
            var decimalString = ""
            
            if timerSeconds < 10
            {
                secondsString = "0\(timerSeconds)"
            }
            else
            {
                secondsString = "\(timerSeconds)"
            }
            if timerDecimal < 10
            {
                decimalString = "0\(timerDecimal)"
            }
            else
            {
                decimalString = "\(timerDecimal)"
            }
            
            clockLabel.text = "\(timerMinutes):" + secondsString + ":" + decimalString

            
        }
        
      
        
        
    }
    
    func createInstruction() {
        
        let previousInteger = randomInteger
        
        randomInteger = Int(arc4random_uniform(4))
        
        while randomInteger == previousInteger
        {
            randomInteger = Int(arc4random_uniform(4))
        }
        
        switch randomInteger {
            
        case 0:
            instructionLabel.text = "Tap"
        case 1:
            instructionLabel.text = "Pinch"
        case 2:
            chooseSwipeDirection()
        case 3:
            instructionLabel.text = "Long Press"
        default:
            instructionLabel.text = "Tap"
            
        }
        
    }
    
    func chooseSwipeDirection() {
        
        swipeCode = Int(arc4random_uniform(4))
        
        switch swipeCode
        {
            
        case 0:
            instructionLabel.text = "Swipe up"
        case 1:
            instructionLabel.text = "Swipe Right"
        case 2:
            instructionLabel.text = "Swipe Down"
        case 3:
            instructionLabel.text = "Swipe Left"
        default:
            instructionLabel.text = "Swipe up"
            
        }
        
        
    }
    
    func correct()
    {
        currentProgress += Int(amountToProgress * 100)
        
        if gameMode == "Online"
        {
            sendData("Progress")
        }
        
        numberCorrect += Int(amountToProgress * 100)
    
        progressBar.progress += amountToProgress
        
        if progressBar.progress > 0.99
        {
            if gameMode == "Online"
            {
                sendData("Victory")

            }
            
            win()
        }
        else
        {
            correctLabel.textColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0)
            correctLabel.text = "Correct!"
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.5
            scaleAnimation.duration = 0.25
            scaleAnimation.repeatCount = 1
            scaleAnimation.autoreverses = true
            correctLabel.layer.add(scaleAnimation, forKey: nil)
            
            if currentProgress < 0
            {
                currentProgress = 0
            }
            
            progressLabel.text = "\(currentProgress)/100"
            
            createInstruction()
        }

    }
    
    func incorrect()
    {
        let noPenalty = UserDefaults.standard.bool(forKey: "noPenalty")
        
        if hasPenalty && !noPenalty
        {
            currentProgress -= Int(amountToProgress * 100)
        }
        
        if gameMode == "Online"
        {
            sendData("Progress")
        }
        
        numberIncorrect += Int(amountToProgress * 100)
        
        if progressBar.progress > 0
        {
            if hasPenalty && !noPenalty
            {
                progressBar.progress -= amountToProgress
            }
        }
        
        correctLabel.textColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1.0)
        correctLabel.text = "incorrect!"
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.5
        scaleAnimation.duration = 0.25
        scaleAnimation.repeatCount = 1
        scaleAnimation.autoreverses = true
        correctLabel.layer.add(scaleAnimation, forKey: nil)
        
        if currentProgress < 0
        {
            currentProgress = 0
        }
        
        progressLabel.text = "\(currentProgress)/100"

        createInstruction()


    }
    
    func win()
    {
        gameTimer.invalidate()
        isGameReady = false
        view.isUserInteractionEnabled = false
        
        let summary = storyboard?.instantiateViewController(withIdentifier: "Summary") as! SummaryViewController
        
        if gameMode == "Time Trials"
        {
            let highMinutes = UserDefaults.standard.integer(forKey: "highScoreMinutes")
            let highSeconds = UserDefaults.standard.integer(forKey: "highScoreSeconds")
            let highDecimal = UserDefaults.standard.integer(forKey: "highScoreDecimal")
            
            let currentGameScore = (timerMinutes * 60) + timerSeconds
            
            let highScore = (highMinutes * 60) + highSeconds
            
            if (currentGameScore < highScore) || (highScore == 0)
            {
                UserDefaults.standard.set(timerMinutes, forKey: "highScoreMinutes")
                UserDefaults.standard.set(timerSeconds, forKey: "highScoreSeconds")
                UserDefaults.standard.set(timerDecimal, forKey: "highScoreDecimal")
                
                UserDefaults.standard.synchronize()
                
                summary.isHighScore = true
                
            }
            else if currentGameScore == highScore
            {
                if timerDecimal < highDecimal
                {
                    UserDefaults.standard.set(timerDecimal, forKey: "highScoreDecimal")
                    
                    UserDefaults.standard.synchronize()
                    
                    summary.isHighScore = true
                }
            }
        }
        
        
        summary.summaryGameMode = gameMode
        summary.gameMinutes = timerMinutes
        summary.gameSeconds = timerSeconds
        summary.gameDecimal = timerDecimal
        summary.correct = numberCorrect
        summary.incorrect = numberIncorrect
        summary.powerUps = powerUpsUsed
        
        if gameMode == "Time Trials"
        {
            summary.highScore = opponentLabel.text!
        }
        
        if gameMode == "Online"
        {
            currentMatch = nil
            
            var wins = UserDefaults.standard.integer(forKey: "wins")
            
            wins += 1
            
            UserDefaults.standard.set(wins, forKey: "wins")
            
            UserDefaults.standard.synchronize()
            
            summary.didWin = true
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            for element in self.view.subviews
            {
                let eachView: UIView = element 
                
                if eachView.isKind(of: UIImageView.self)
                {
                    if eachView.tag == 1
                    {
                        eachView.alpha = 0.0

                    }
                    else
                    {
                        eachView.alpha = 1.0

                    }
                    
                }
                else
                {
                    eachView.alpha = 0.0
                    
                }
                
            }
            
            }) { (success) -> Void in
                
                self.navigationController?.pushViewController(summary, animated: false)

        }

        
       
    }
    
    func loss()
    {
        gameTimer.invalidate()
        isGameReady = false
        view.isUserInteractionEnabled = false
        
        let summary = storyboard?.instantiateViewController(withIdentifier: "Summary") as! SummaryViewController
        
        summary.summaryGameMode = gameMode
        summary.correct = numberCorrect
        summary.incorrect = numberIncorrect
        
        if gameMode == "Online"
        {
            currentMatch = nil
            
            var losses = UserDefaults.standard.integer(forKey: "losses")
            
            losses += 1
            
            UserDefaults.standard.set(losses, forKey: "losses")
            
            UserDefaults.standard.synchronize()
            
            summary.didWin = false
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            for element in self.view.subviews
            {
                let eachView: UIView = element 
                
                if eachView.isKind(of: UIImageView.self)
                {
                    if eachView.tag == 1
                    {
                        eachView.alpha = 0.0
                        
                    }
                    else
                    {
                        eachView.alpha = 1.0
                        
                    }
                    
                }
                else
                {
                    eachView.alpha = 0.0
                    
                }
                
            }
            
            }) { (success) -> Void in
                
                self.navigationController?.pushViewController(summary, animated: false)
                
        }

    }

    
    //gestures
    
    func checkRecognizer(_ sender: UIGestureRecognizer)
    {
        if sender.state == .ended && hasCountdownEnded && !isPaused
        {
            isGameReady = true
        }
        
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        if isGameReady
        {
            
            isGameReady = false
            
            if randomInteger == 0
            {
                correct()
            }
            else
            {
                incorrect()
            }
            
        }

        if sender.state == .ended
        {
            isGameReady = true
        }
        
    }
    
    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        
        if isGameReady
        {
            
            isGameReady = false
            
            if randomInteger == 1
            {
                correct()
                
            }
            else
            {
                incorrect()
            }
            
        }
            
      
        if sender.state == .ended
        {
            isGameReady = true
        }
        
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        
        if isGameReady
        {
            isGameReady = false
            
            if randomInteger == 2
            {
                if swipeCode == 0 && sender.direction == .up
                {
                    correct()
                }
                else if swipeCode == 1 && sender.direction == .right
                {
                    correct()
                    
                }
                else if swipeCode == 2 && sender.direction == .down
                {
                    correct()
                    
                }
                else if swipeCode == 3 && sender.direction == .left
                {
                    
                    correct()
                }
                else
                {
                    incorrect()
                }
                
            }
            else
            {
                incorrect()
            }
            
        }
     
        if sender.state == .ended
        {
            isGameReady = true
        }
        
    }
    
    @IBAction func longPressGesture(_ sender: UILongPressGestureRecognizer) {
     
        if isGameReady
        {
            
            isGameReady = false
            
            if randomInteger == 3
            {
                correct()
            }
            else
            {
                incorrect()
            }
            
        }
            
       
        if sender.state == .ended
        {
            isGameReady = true
        }

    }
    
    
    //power ups
    
    @IBAction func powerUpOne(_ sender: AnyObject) {
        
        clearTimer.invalidate()
        zapUpdateTimer.invalidate()
        multiplyTimer.invalidate()
        defenseTimer.invalidate()
        
        if canUsePowerUps
        {
            powerUpsUsed += 1
            
            let unlimited = UserDefaults.standard.bool(forKey: "unlimited")
            
            if !unlimited
            {
                currentCoins -= 7500
                
                UserDefaults.standard.set(currentCoins, forKey: "coins")
                UserDefaults.standard.synchronize()
            }
            
            checkCoinLevels()
            
            if gameMode == "Online"
            {
                sendData("Power Up 1")
                
                powerUp1Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.powerUp1Cooldown), userInfo: nil, repeats: true)
                
                activityLabel.text = "You zapped your opponent for 10s!"
                
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = 1.0
                scaleAnimation.toValue = 1.1
                scaleAnimation.duration = 0.25
                scaleAnimation.repeatCount = 1
                scaleAnimation.autoreverses = true
                activityLabel.layer.add(scaleAnimation, forKey: nil)
                
                zapUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.updateZapCountdown), userInfo: nil, repeats: true)
                
            }
            else if gameMode == "Time Trials"
            {
                gameTimer.invalidate()
                
                activityLabel.text = "You zapped the clock for 10s!"
                
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = 1.0
                scaleAnimation.toValue = 1.1
                scaleAnimation.duration = 0.25
                scaleAnimation.repeatCount = 1
                scaleAnimation.autoreverses = true
                activityLabel.layer.add(scaleAnimation, forKey: nil)
                
                zapUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.updateZapCountdown), userInfo: nil, repeats: true)
                
            }
            
            powerUp1Label.text = "30s"
            
            powerUpOne.isEnabled = false
            powerUpOne.alpha = 0.4
            
            powerUp1Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.powerUp1Cooldown), userInfo: nil, repeats: true)

        }
        else
        {
            activityLabel.text = "Your opponent prevented you from using power ups!"
        }
        
    }
    
    func zapCountdown()
    {
        instructionLabel.textColor = UIColor.white
        
        isGameReady == true
        self.view.isUserInteractionEnabled = true
        
        createInstruction()
        
    }
    
    func updateZapCountdown()
    {
        zap10 -= 1
        
        if gameMode == "Online"
        {
            activityLabel.text = "You zapped your opponent for \(zap10)s!"

        }
        else if gameMode == "Time Trials"
        {
            activityLabel.text = "You zapped the clock for \(zap10)s!"

        }
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.1
        scaleAnimation.duration = 0.25
        scaleAnimation.repeatCount = 1
        scaleAnimation.autoreverses = true
        activityLabel.layer.add(scaleAnimation, forKey: nil)
        
        if zap10 <= 0
        {
            zapUpdateTimer.invalidate()
            
            activityLabel.text = ""
            
            zap10 = 10
            
        }
        
    }

    @IBAction func powerUpTwo(_ sender: AnyObject) {
        
        clearTimer.invalidate()
        zapUpdateTimer.invalidate()
        multiplyTimer.invalidate()
        defenseTimer.invalidate()
        
        if canUsePowerUps
        {
            powerUpsUsed += 1
            
            let unlimited = UserDefaults.standard.bool(forKey: "unlimited")
            
            if !unlimited
            {
                currentCoins -= 2500
                
                UserDefaults.standard.set(currentCoins, forKey: "coins")
                UserDefaults.standard.synchronize()
            }
            
            checkCoinLevels()
            
            progressBar.progress += 0.10
            
            currentProgress += 10
            
            progressLabel.text = "\(currentProgress)/100"
            
            activityLabel.text = "You boosted ahead for 10 fuel points!"
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.1
            scaleAnimation.duration = 0.25
            scaleAnimation.repeatCount = 1
            scaleAnimation.autoreverses = true
            activityLabel.layer.add(scaleAnimation, forKey: nil)
            
            clearTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(GameViewController.clearActivityLabel), userInfo: nil, repeats: false)
            
            if gameMode == "Online"
            {
                sendData("Progress")
                
                sendData("Power Up 2")
                
                powerUp2Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.powerUp2Cooldown), userInfo: nil, repeats: true)
                
            }
            else if gameMode == "Time Trials"
            {
                
            }
            
            powerUp2Label.text = "30s"
            
            powerUpTwo.isEnabled = false
            powerUpTwo.alpha = 0.4
            
            powerUp2Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.powerUp2Cooldown), userInfo: nil, repeats: true)

        }
        else
        {
            activityLabel.text = "Your opponent prevented you from using power ups!"
        }
        
    }
    
    func clearActivityLabel()
    {
        activityLabel.text = ""
    }
    
    @IBAction func powerUpThree(_ sender: AnyObject) {
        
        clearTimer.invalidate()
        zapUpdateTimer.invalidate()
        multiplyTimer.invalidate()
        defenseTimer.invalidate()
        
        if canUsePowerUps
        {
            if gameMode == "Online"
            {
                sendData("Power Up 3")
            }
            
            powerUpsUsed += 1
            
            let unlimited = UserDefaults.standard.bool(forKey: "unlimited")
            
            if !unlimited
            {
                currentCoins -= 5000
                
                UserDefaults.standard.set(currentCoins, forKey: "coins")
                UserDefaults.standard.synchronize()
            }
            
            checkCoinLevels()
            
            amountToProgress = 0.02
            
            activityLabel.text = "You multiplied your progress for 10s!"
            
            multiplyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.multiplyCountdown), userInfo: nil, repeats: true)
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.1
            scaleAnimation.duration = 0.25
            scaleAnimation.repeatCount = 1
            scaleAnimation.autoreverses = true
            activityLabel.layer.add(scaleAnimation, forKey: nil)
            
            powerUp3Label.text = "30s"
            
            powerUpThree.isEnabled = false
            powerUpThree.alpha = 0.4
            
            powerUp3Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.powerUp3Cooldown), userInfo: nil, repeats: true)

        }
        else
        {
            activityLabel.text = "Your opponent prevented you from using power ups!"
        }
        
        
    }
    
    func multiplyCountdown()
    {
        multiply10 -= 1
        
        activityLabel.text = "You multiplied your progress for \(multiply10)s!"
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.1
        scaleAnimation.duration = 0.25
        scaleAnimation.repeatCount = 1
        scaleAnimation.autoreverses = true
        activityLabel.layer.add(scaleAnimation, forKey: nil)
        
        if multiply10 <= 0
        {
            multiplyTimer.invalidate()
            
            multiply10 = 10
            
            activityLabel.text = ""
        }
        
    }
    
    @IBAction func powerUpFour(_ sender: AnyObject) {
        
        clearTimer.invalidate()
        zapUpdateTimer.invalidate()
        multiplyTimer.invalidate()
        defenseTimer.invalidate()
        
        if canUsePowerUps
        {
            powerUpsUsed += 1
            
            let unlimited = UserDefaults.standard.bool(forKey: "unlimited")
            
            if !unlimited
            {
                currentCoins -= 10000
                
                UserDefaults.standard.set(currentCoins, forKey: "coins")
                UserDefaults.standard.synchronize()
            }
            
            checkCoinLevels()
            
            if gameMode == "Online"
            {
                sendData("Power Up 4")
                
                activityLabel.text = "You prevented \(opponentAlias) from using power ups!"
                
            }
            else if gameMode == "Time Trials"
            {
                hasPenalty = false
                
                defenseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.defenseCountdown), userInfo: nil, repeats: true)
                
                activityLabel.text = "You destroyed the penalty for 30s!"
                
            }
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.1
            scaleAnimation.duration = 0.25
            scaleAnimation.repeatCount = 1
            scaleAnimation.autoreverses = true
            activityLabel.layer.add(scaleAnimation, forKey: nil)
            
            powerUp4Label.text = "30s"
            
            powerUpFour.isEnabled = false
            powerUpFour.alpha = 0.4
            
            powerUp4Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.powerUp4Cooldown), userInfo: nil, repeats: true)

        }
        else
        {
            activityLabel.text = "Your opponent prevented you from using power ups!"
        }
        
        
    }
    
    func defenseCountdown()
    {
        defense30 -= 1
        
        activityLabel.text = "You destroyed the penalty for \(defense30)s"
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.1
        scaleAnimation.duration = 0.25
        scaleAnimation.repeatCount = 1
        scaleAnimation.autoreverses = true
        activityLabel.layer.add(scaleAnimation, forKey: nil)
        
        if defense30 <= 0
        {
            defenseTimer.invalidate()
            
            defense30 = 30
            
            activityLabel.text = ""
            
            hasPenalty = true
        }

    }
    
    func powerUp1Cooldown()
    {
        powerUp1Countdown -= 1

        if gameMode == "Time Trials"
        {
            if powerUp1Countdown == 20
            {
                gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameViewController.gameCountdown), userInfo: nil, repeats: true)
            }
            
        }
        
        if powerUp1Countdown <= 0
        {
            powerUp1Timer.invalidate()
            
            if currentCoins < 7500
            {
                powerUpOne.isEnabled = false
                powerUpOne.alpha = 0.4
                
                powerUp1Label.text = "Add Coins"
                
            }
            else
            {
                powerUp1Label.text = "Ready!"
                
                powerUpOne.isEnabled = true
                
                powerUpOne.alpha = 1.0
            }

            powerUp1Countdown = 30
        }
        else
        {
            powerUp1Label.text = "\(powerUp1Countdown)s"
            
            powerUpOne.isEnabled = false
        }
        
        
    }
    
    func powerUp2Cooldown()
    {
        powerUp2Countdown -= 1
        
        if powerUp2Countdown <= 0
        {
            
            powerUp2Timer.invalidate()
            
            if currentCoins < 2500
            {
                powerUpTwo.isEnabled = false
                powerUpTwo.alpha = 0.4
                
                powerUp2Label.text = "Add Coins"
                
            }
            else
            {
                powerUp2Label.text = "Ready!"
                
                powerUpTwo.isEnabled = true
                
                powerUpTwo.alpha = 1.0
            }
            
            powerUp2Countdown = 30
            
        }
        else
        {
            powerUp2Label.text = "\(powerUp2Countdown)s"
            
            powerUpTwo.isEnabled = false
        }
        
        
    }
    
    func powerUp3Cooldown()
    {
        powerUp3Countdown -= 1
        
        if powerUp3Countdown <= 20
        {
            amountToProgress = 0.01
        }
        
        if powerUp3Countdown <= 0
        {
            powerUp3Timer.invalidate()
            
            if currentCoins < 5000
            {
                powerUpThree.isEnabled = false
                powerUpThree.alpha = 0.4
                
                powerUp3Label.text = "Add Coins"
                
            }
            else
            {
                powerUp3Label.text = "Ready!"
                
                powerUpThree.isEnabled = true
                
                powerUpThree.alpha = 1.0
            }
            
            powerUp3Countdown = 30
        }
        else
        {
            powerUp3Label.text = "\(powerUp3Countdown)s"
            
            powerUpThree.isEnabled = false
        }
        

    }
    
    func powerUp4Cooldown()
    {
        powerUp4Countdown -= 1
        
        if powerUp4Countdown <= 0
        {
            hasPenalty = true
            
            powerUp4Timer.invalidate()
            
            if currentCoins < 10000
            {
                powerUpFour.isEnabled = false
                powerUpFour.alpha = 0.4
                
                powerUp4Label.text = "Add Coins"
                
            }
            else
            {
                powerUp4Label.text = "Ready!"
                
                powerUpFour.isEnabled = true
                
                powerUpFour.alpha = 1.0
            }

            
            powerUp4Countdown = 30
        }
        else
        {
            powerUp4Label.text = "\(powerUp4Countdown)s"
            
            powerUpFour.isEnabled = false
        }
        
        
    }
    
    func checkCoinLevels()
    {
        
        if !UserDefaults.standard.bool(forKey: "unlimited")
        {
            if currentCoins < 2500
            {
                powerUpTwo.isEnabled = false
                powerUpTwo.alpha = 0.4
                
                powerUp2Label.text = "Add Coins"
                
            }
            else
            {
                //powerUp2Label.text = "Ready!"
                
                powerUpTwo.isEnabled = true
            }
            
            if currentCoins < 5000
            {
                powerUpThree.isEnabled = false
                powerUpThree.alpha = 0.4
                
                powerUp3Label.text = "Add Coins"
                
            }
            else
            {
                //powerUp3Label.text = "Ready!"
                
                powerUpThree.isEnabled = true
            }
            
            if currentCoins < 7500
            {
                powerUpOne.isEnabled = false
                powerUpOne.alpha = 0.4
                
                powerUp1Label.text = "Add Coins"
                
            }
            else
            {
               // powerUp1Label.text = "Ready!"
                
                powerUpOne.isEnabled = true
            }
            
            if currentCoins < 10000
            {
                powerUpFour.isEnabled = false
                powerUpFour.alpha = 0.4
                
                powerUp4Label.text = "Add Coins"
                
            }
            else
            {
                //powerUp4Label.text = "Ready!"
                
                powerUpFour.isEnabled = true
            }
        }
        else
        {
            powerUpOne.isEnabled = true
            powerUpTwo.isEnabled = true
            powerUpThree.isEnabled = true
            powerUpFour.isEnabled = true
            
            powerUpOne.alpha = 1.0
            powerUpTwo.alpha = 1.0
            powerUpThree.alpha = 1.0
            powerUpFour.alpha = 1.0
            
            powerUp1Label.text = "Ready!"
            powerUp2Label.text = "Ready!"
            powerUp3Label.text = "Ready!"
            powerUp4Label.text = "Ready!"
        }
      
        
        coinsLabel.text = "Coins: \(currentCoins)"
        
    }
    

    //pause menu
    
    @IBAction func pauseButton(_ sender: AnyObject) {
        
        if gameMode == "Online"
        {
            pauseMenu = PauseMenu()
            pauseMenu.frame = CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height/2 - 50, width: 200, height: 150)
            pauseMenu.parent = self
            pauseMenu.isOpaque = false
            pauseMenu.pauseGameMode = gameMode
            
            pauseButton.isEnabled = false
            powerUpOne.isEnabled = false
            powerUpTwo.isEnabled = false
            powerUpThree.isEnabled = false
            powerUpFour.isEnabled = false
            
            for gameView in self.view.subviews
            {
                let pauseView = gameView 
                
                pauseView.alpha = 0.8
            }
            
            self.view.addSubview(pauseMenu)

        }
        else if gameMode == "Time Trials"
        {
            gameTimer.invalidate()
            
            pauseMenu = PauseMenu()
            pauseMenu.frame = CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height/2 - 75, width: 200, height: 150)
            pauseMenu.parent = self
            pauseMenu.isOpaque = false
            pauseMenu.pauseGameMode = gameMode
            
            isPaused = true
            isGameReady = false
            pauseButton.isEnabled = false
            powerUpOne.isEnabled = false
            powerUpTwo.isEnabled = false
            powerUpThree.isEnabled = false
            powerUpFour.isEnabled = false
            
            for gameView in self.view.subviews
            {
                let pauseView = gameView 
                
                pauseView.alpha = 0.8
            }
            
            self.view.addSubview(pauseMenu)
            
            powerUp1Timer.invalidate()
            powerUp2Timer.invalidate()
            powerUp3Timer.invalidate()
            powerUp4Timer.invalidate()


        }
        
    }
    
    func resumeGame()
    {
        pauseMenu.removeFromSuperview()
        pauseButton.isEnabled = true
        
        self.view.tintAdjustmentMode = UIViewTintAdjustmentMode.automatic
        
        if powerUp1Countdown != 30
        {
            powerUp1Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.powerUp1Cooldown), userInfo: nil, repeats: true)
        }
        if powerUp2Countdown != 30
        {
            powerUp2Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.powerUp2Cooldown), userInfo: nil, repeats: true)
        }
        if powerUp3Countdown != 30
        {
            powerUp3Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.powerUp3Cooldown), userInfo: nil, repeats: true)
        }
        if powerUp4Countdown != 30
        {
            powerUp4Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.powerUp4Cooldown), userInfo: nil, repeats: true)
        }
        
        for gameView in self.view.subviews
        {
            let pauseView = gameView 
            
            pauseView.alpha = 1.0
        }
        
        if gameMode == "Online"
        {
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.gameCountdown), userInfo: nil, repeats: true)
        }
        else if gameMode == "Time Trials"
        {
            gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameViewController.gameCountdown), userInfo: nil, repeats: true)
        }
        
        isGameReady = true
        hasCountdownEnded = true
        isPaused = false
        
    
    }
    
    func restartGame()
    {
        pauseMenu.removeFromSuperview()
        
        self.view.tintAdjustmentMode = UIViewTintAdjustmentMode.automatic
        
        for gameView in self.view.subviews
        {
            let pauseView = gameView 
            
            pauseView.alpha = 1.0
        }
        
        progressBar.progress = 0.0
        progressLabel.text = "\(Int(progressBar.progress * 100))/100"
        
        countdownNumber = 5
        randomInteger = 4
        swipeCode = 0
        isGameReady = false
        numberCorrect = 0
        numberIncorrect = 0
        hasCountdownEnded = false
        isPaused = false
        
        if gameMode == "Online"
        {
            timerMinutes = 5
            timerSeconds = 0
            timerDecimal = 0
            clockLabel.text = "5:00"
        }
        
        if gameMode == "Time Trials"
        {
            timerMinutes = 0
            timerSeconds = 0
            timerDecimal = 0
            clockLabel.text = "0:00.00"
        }
        
        
        
        countdownLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2 - 75, width: 150, height: 150))
        countdownLabel.text = String(countdownNumber)
        countdownLabel.font = UIFont(name: "Star Jedi", size: 50)
        countdownLabel.adjustsFontSizeToFitWidth = true
        countdownLabel.textAlignment = .center
        countdownLabel.textColor = UIColor.white
        
        self.view.addSubview(countdownLabel)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.5
        scaleAnimation.duration = 0.25
        scaleAnimation.repeatCount = 1
        scaleAnimation.autoreverses = true
        countdownLabel.layer.add(scaleAnimation, forKey: nil)

        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.countdown), userInfo: nil, repeats: true)
        
        
        correctLabel.text = ""
        instructionLabel.text = ""

    }
    
    func quitGame()
    {
        
        if gameMode == "Online"
        {
            currentMatch!.disconnect()
            
            currentMatch = nil
            
        }
        
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
