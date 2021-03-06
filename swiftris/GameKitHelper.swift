//
//  GameKitHelper.swift
//  Swiftris
//
//  Created by RH Blanchfield on 3/31/15.
//  Copyright (c) 2015 artchiteq. All rights reserved.
//
import Foundation
import GameKit
import UIKit


enum GameMode {
    case Classic
    case Timed
}

class GameKitHelper {
    
    var scene: GameScene!
    var swiftris: Swiftris!
    
    var gameCenterEnabled: Bool
    var leaderboardIdentifier: String

    
    init () {
        gameCenterEnabled = true
        leaderboardIdentifier = ""
    }
    
    func authenticateLocalPlayer(presentingVC : UIViewController) {
        var localPlayer = GKLocalPlayer()
        
        localPlayer.authenticateHandler = {(viewController : UIViewController!, error : NSError!) -> Void in
            if viewController != nil {
                presentingVC.presentViewController(viewController, animated: true, completion: nil)
            } else {
                if localPlayer.authenticated {
                    self.gameCenterEnabled = true
                    
                    localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifier : String!, error : NSError!) -> Void in
                        if error != nil {
                            println(error.localizedDescription)
                        } else {
                            self.leaderboardIdentifier = leaderboardIdentifier
                        }
                    })
                } else {
                    self.gameCenterEnabled = false
                }
            }
        }
    }
    
    func reportScores(score: Int64) {
        let highScores = GKScore(leaderboardIdentifier: leaderboardIdentifier)
        highScores.value = score
        
        GKScore.reportScores([highScores],
            withEligibleChallenges:nil,
            withCompletionHandler: { (error:NSError!) -> Void in
            
            if (error != nil) {
                println("Error: " + error.localizedDescription)
            }
        })
    }
    
    func showLeaderboardAndAchievement(shouldShowLeaderboard: Bool) {
        var gcViewController: GKGameCenterViewController!
        var vc: UIViewController!
        
        gcViewController.gameCenterDelegate?
        
        if shouldShowLeaderboard {
            gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
            gcViewController.leaderboardIdentifier = leaderboardIdentifier
        } else {
            gcViewController.viewState = GKGameCenterViewControllerState.Achievements
        }
        
        vc.view.window?.rootViewController?.presentViewController(gcViewController, animated: true, completion: nil)
    }
    
    /*func updateAchievements() {
        var achievementIdentifier: NSString
        var progressPercentage = 0.0
        var progressInLevelAchievement: Bool = false
        
        var levelAchievement: GKAchievement?
        var scoreAchievement: GKAchievement?
        
        if progressInLevelAchievement {
            levelAchievement?.identifier = achievementIdentifier
            levelAchievement?.percentComplete = progressPercentage
        }
        
        scoreAchievement?.identifier = achievementIdentifier
        scoreAchievement?.percentComplete = progressPercentage
        
        var theAchievements: [AnyObject?] = [levelAchievement, scoreAchievement]
        /*
        GKAchievement.reportAchievements(achievements:theAchievements, withCompletionHandler: { (error: NSError!) -> Void in
            if (error != nil) {
                println("Error: " + error.localizedDescription)
            }
        })
        */
        GKAchievement.reportAchievements([theAchievements],
            withEligibleChallenges:nil, withCompletionHandler: { (error: NSError!) -> Void in
            if (error != nil) {
                println("Error: " + error.localizedDescription)
            }
        })
    }*/
    
    func resetAchievements() {
        GKAchievement.resetAchievementsWithCompletionHandler { (error: NSError!) -> Void in
            if (error != nil) {
                println("Error: " + error.localizedDescription)
            }
        }
        
    }
    
}


