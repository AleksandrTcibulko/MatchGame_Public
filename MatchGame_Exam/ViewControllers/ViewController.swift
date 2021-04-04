//
//  ViewController.swift
//  MatchGame_Exam
//
//  Created by Tsibulko on 23.08.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer:Timer?
    var seconds = 30
    var minutes = 1
    
    let cardService = CardService()
    var cardsForGame = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        cardsForGame = cardService.getCards()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    } //end of override func viewDidLoad()
    
    override func viewDidAppear(_ animated: Bool) {
        soundPlayer.playSounds(effect: .shuffle)
    }

    
    @objc func timerFired() {
        seconds -= 1
        timerLabel.text = String(format: "Time remaining: %.2d:%.2d", minutes, seconds)
        
        if seconds == 0 {
            minutes -= 1
            seconds = 60
        }
        
        if minutes < 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            checkForGameEnd()
        }
    } // end of @objc func timerFired()
    
    
    func showAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Restart", style: .default) { (action) in
            
                self.minutes = 1
                self.seconds = 30
                self.timerLabel.textColor = UIColor.black
                
                self.soundPlayer.playSounds(effect: .shuffle)
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
                
                self.cardsForGame = self.cardService.getCards()
                self.collectionView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    } // end of func showAlert
    
} //end of class ViewController: UIViewController


// MARK: - Game Logic

extension ViewController {
    
    func matchCards(secondFlippedCardIndex:IndexPath) {
        
        let cardFirst = cardsForGame[firstFlippedCardIndex!.row]
        let cardSecond = cardsForGame[secondFlippedCardIndex.row]
        
        let cardFirstCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardSecondCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        if cardFirst.imageName == cardSecond.imageName {
            
            cardFirst.isMatched = true
            cardSecond.isMatched = true
            
            soundPlayer.playSounds(effect: .match)
            
            cardFirstCell?.remove()
            cardSecondCell?.remove()
            
            checkForGameEnd()
        }
        else {
            cardFirst.isFlipped = false
            cardSecond.isFlipped = false
            
            soundPlayer.playSounds(effect: .nomatch)
            
            cardFirstCell?.flipDown()
            cardSecondCell?.flipDown()
        }
        
        firstFlippedCardIndex = nil
    } //end of func matchCards()
    
    
    func checkForGameEnd() {
        
        var hasWon = true
        
        for card in cardsForGame {
            
            if card.isMatched == false {
                hasWon = false
                break
            }
        } //end of FOR_IN loop
        
        if hasWon == true {
            showAlert(title: "Congrats!", message: "You have won!")
        }
        else {
            if minutes < 0 {
                showAlert(title: "Sorry", message: "Time is out!")
            }
        }
    }//end of func checkForGameEnd()
    
} // end of extension



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsForGame.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cardCell = cell as? CardCollectionViewCell
        
        let card = cardsForGame[indexPath.row]
            
        cardCell?.configureCell(card: card)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false {
            
            cell?.flipUp()
            soundPlayer.playSounds(effect: .flip)
        }
        
        if firstFlippedCardIndex == nil {
            firstFlippedCardIndex = indexPath
        }
        else {
            matchCards(secondFlippedCardIndex: indexPath)
        }
    } //end of collectionView( .... didSelectItemAt indexPath: ..)
    
    
} // end of extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate

