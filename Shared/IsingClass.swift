//
//  IsingClass.swift
//  metropolisAlgorithm
//
//  Created by Matthew Adas on 4/2/21.
//

import Foundation
import SwiftUI

class IsingClass: ObservableObject {
    
    var N = 1000
    var B = 1.0
    var mu = 0.33
    var J = 0.20
    var k = 1.0
    var T = 100000000.0
    
    func energyCalculation(S: [Int]) -> Double {
        var firstTerm = 0.0
        var secondTerm = 0.0
        for i in 1..<(N-2) {
            //numbers.append(1)
            firstTerm += Double(S[i] * S[i+1])
        }
        firstTerm *= -J
        
        for i in 1..<(N-1) {
            secondTerm += Double(S[i])
        }
        secondTerm *= -B*mu
        
        return (firstTerm + secondTerm)
    
    }

}


