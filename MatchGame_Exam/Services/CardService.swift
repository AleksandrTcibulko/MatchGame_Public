//
//  CardService.swift
//  MatchGame_Exam
//
//  Created by Tsibulko on 24.08.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import Foundation
import UIKit

class CardService {
    
    func getCards() -> [Card] {
        
        var arrayOfCards = [Card]()
        
        var arrayOfRandomNumbers = [Int]()
        
        while arrayOfRandomNumbers.count < 8 {
            
            let randomNumber = Int.random(in: 1...13)
            
            if arrayOfRandomNumbers.contains(randomNumber) == false {
                
                let cardOne = Card()
                let cardTwo = Card()
                
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                arrayOfRandomNumbers.append(randomNumber)
                arrayOfCards += [cardOne, cardTwo]
                
            } //end of IF statement
            
        } //end of while loop
        
        return arrayOfCards.shuffled()
        
    } //end of func getCards()
    
    
} //end of class CardService
