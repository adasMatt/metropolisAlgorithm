//
//  ContentView.swift
//  Shared
//
//  Created by Matthew Adas on 4/2/21.
//  Landau 15.4.1 Metropolis Algorithm Implementation

// for hot start option search "initialStateTextString = "hot start"" and remove un-comment the block until picker is added

// to work on animating spin flips:
// search "plot state and trial"
// same as above search "animate spin flip from original ET (aka plot trial again?)"

import SwiftUI

struct ContentView: View {
    
    @State var initialStateString = "[1, 1, 1, ...] (array generated when program runs)"
    @State var initialStateTextString = "cold start (see code for \"hot start\" need to add a picker)"
    @State var trialString = ""
    @State var energyString = " "
    
    @State var ising = IsingClass()
    
    var body: some View {
        
        Text(initialStateTextString)
            .padding()
        TextEditor(text: $initialStateString)
        
        Text("randomly flipped state")
            .padding()
        TextEditor(text: $trialString)
        
        
        // button
        Button("Generate random states", action: randomNumber)
            .padding()
    }
    
    func randomNumber() {
        
        var state: [Int] = []
        
        // populate "numbers" with N = 1,000 1's (not sure if N will ever change or be user selectable)
        //
        for _ in 1..<ising.N {
            state.append(-1)
        }
        
        
        // multiply -1 to random members of numbers array using large number "M" for effective randomizer
        let M = 5 * ising.N // (not sure if N will ever change or be user selectable)
        // this for loop is for a "hot start" ...comment it out for a "cold start"
        /*
         initialStateTextString = "hot start"
         for _ in 1..<M {
            // sequence to choose random member of "numbers" array and multiply by -1
            let nthMember = Int.random(in: 0..<ising.N-1)
            state[nthMember] *= -1
        }*/
        
        // are these two lines neccesary or isn't it already random enough from the for loop?
        //let shuffledNumbers = (numbers as NSArray).shuffled() as! [Int]
        //initialStateString = "\(shuffledNumbers)"
        var ES = ising.energyCalculation(S: state)
        initialStateString = "\(state)"
        
        // apply randomizer again to initial state
        var trialRandomFlip = state
        print("begin")
        for _ in 1..<M {
            
            // generate trial state
            let nthMember = Int.random(in: 0..<ising.N-1)
            trialRandomFlip[nthMember] *= -1
            
            // plot state and trial
            
            
            // fix trial state using probability
            let ET = ising.energyCalculation(S: trialRandomFlip)
            let p = exp((ES-ET)/ising.k*ising.T)
            let randnum = Double.random(in: 0...1)
            if (p >= randnum) {
                state = trialRandomFlip     // wait but it changes the whole thing with every loop?
                ES = ET                     // ES stays as is if p < randnum
                
                // animate spin flip from original ET (aka plot trial again?)
            }
            
            print(ES)
            
            
        }
        
        
        trialString = "\(trialRandomFlip)"
                
    }
    
}




// ////////////////////////////////////////////////// //
// /////////////// stuff to not touch /////////////// //
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
