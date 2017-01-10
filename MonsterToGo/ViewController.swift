//
//  ViewController.swift
//  MonsterToGo
//
//  Created by Niklas Danz on 24.09.16.
//  Copyright © 2016 Niklas Danz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: Constants & Variables
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: Timer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    
    // MARK: Outlets
    
    @IBOutlet weak var restartBtn: UIButton!
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var foodImg: DragImg!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "cave-music", ofType: ".mp3")!))
            try sfxBite = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "bite", ofType: ".wav")!))
            try sfxHeart = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "heart", ofType: ".wav")!))
            try sfxDeath = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "death", ofType: ".wav")!))
            try sfxSkull = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "skull", ofType: ".wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        dimPenaltyImages()
        startTimer()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        // NOTIFICATION LISTENER
        // if heartImg or foodImg is dragged onto the monster, this function triggers
        // the function itemDropped...
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDroppedOnCharacter), name: NSNotification.Name(rawValue: "onTargetDropped"), object: nil)
    }

    // MARK: Functions
    
    @IBAction func restartBtnPressed(_ sender: AnyObject) {
        // restart game
        penalties = 0
        monsterHappy = false
        currentItem = 0
        dimPenaltyImages()
        monsterImg.playIdleAnimation()
        
        startTimer()
        
        restartBtn.isHidden = true
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
        
        disableFoodAndHeart()
    }
    
    func dimPenaltyImages() {
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties += 1
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
            } else if penalties == 2 {
                penalty2Img.alpha = OPAQUE
            } else if penalties == 3 {
                penalty3Img.alpha = OPAQUE
            } else {
                dimPenaltyImages()
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2) // 0 or 1
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.isUserInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.isUserInteractionEnabled = true
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.isUserInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.isUserInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        disableFoodAndHeart()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
        
        restartBtn.isHidden = false;
    }
    
    func disableFoodAndHeart() {
        foodImg.alpha = DIM_ALPHA
        foodImg.isUserInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.isUserInteractionEnabled = false
    }


}

