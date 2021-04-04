//
//  CardCollectionViewCell.swift
//  MatchGame_Exam
//
//  Created by Tsibulko on 24.08.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card) {
        
        self.card = card
        
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatched == true {
            frontImageView.alpha = 0
            backImageView.alpha = 0
            return
        }
        else {
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        
        if card.isFlipped == true {
            flipUp(speed: 0)
        }
        else {
            flipDown(speed: 0, delay: 0)
        }
    } // end of func configureCell
    
    
    func flipUp(speed:TimeInterval = 0.5) {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        
        card?.isFlipped = true
    }
    
    
    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.3) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        card?.isFlipped = false
    }
    
    
    func remove() {
        
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
    
    
    func restart() {
        frontImageView.alpha = 1
        backImageView.alpha = 1
    }
    
} //end of class CardCollectionViewCell: UICollectionViewCell
