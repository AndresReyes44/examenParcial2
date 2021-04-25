//
//  SequenceGenerator.swift
//  FredGame
//
//  Created by user188455 on 3/14/21.
//

import Foundation

class SequenceGenerator {
    func getSequenceList(size : Int) -> [Int] {
        var fixedSequence : [Int] = []
        
        for _ in 1...size {
            let number = Int.random(in: 1...9)
            fixedSequence.append(number)
        }
        
        return fixedSequence
    }
}
