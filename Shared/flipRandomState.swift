//
//  flipRandomState.swift
//  metropolisAlgorithm
//
//  Created by Matthew Adas on 4/9/21.
//

import Foundation
import SwiftUI


class FlipRandomState: ObservableObject {
    //@Published var start = DispatchTime.now() //Start time
    @Published var stop = DispatchTime.now()  //Stop tim
    @Published var stateString = ""
    @State var initialStateTextString = "cold start (see code for \"hot start\" need to add a picker)"
    
    // but should I call IsingClass here or should this just be part of IsingClass, used here: "var ES = ising.energyCalculation(S: state, N: N)"
    @State var ising = IsingClass()
    
     /* should correspond to my randomNumber function
     func integration(iterations: Int, guesses: Int, integrationQueue: DispatchQueue){
         var integralArray :[Double] = []
         start = DispatchTime.now() // starting time of the integration
         
         integrationQueue.async{
             DispatchQueue.concurrentPerform(iterations: Int(iterations), execute: { index in
                 
                 if self.shouldIDisplay {
                     DispatchQueue.main.async{
                     
                         //Update Display With Started Queue Thread On the Main Thread
                         self.outputText += "started index \(index)" + "\n"
                     }
                 }
                 
                 integralArray.append(self.calculateMonteCarloIntegral(dimensions: 1, guesses: Int32(guesses), index: index))
             })
             
             //Calculate the volume of the Bounding Box of the Monte Carlo Integration
             let boundingBox = BoundingBox()
                 
             boundingBox.initWithDimensionsAndRanges(dimensions: 1, lowerBound: [0.0], upperBound: [1.0])
             
             let volume = boundingBox.volume
             
             //Create the average value by dividing by the number of guesses
             //Calculate the integral by multiplying by the volume of the bounding box (limits of integration).
             let integralValue = integralArray.map{$0 * (volume / Double(guesses))}
             
             let myIntegral = integralValue.mean
             self.integral = myIntegral
             
             DispatchQueue.main.async{
                 
                 //Update Display With Results of Calculation on the Main Thread
                 self.disableIntegrateButton = false
                 self.integral = myIntegral
                 self.integralString = "\(myIntegral)"
                 let totalGuesses = Double(guesses)*Double(iterations)
                 self.totalGuessesString = "\(totalGuesses)"
                 self.exactString = "\(self.exact)"
                 self.logError = log10( abs(myIntegral-self.exact)/self.exact)
                 self.logErrorString = "\(self.logError)"
                 self.stop = DispatchTime.now()    //end time
                 let nanotime :UInt64 = self.stop.uptimeNanoseconds - self.start.uptimeNanoseconds //difference in nanoseconds from the start of the calculation until the end.
                 let timeInterval = Double(nanotime) / 1_000_000_000
                 self.timeString = "\(timeInterval)"
             }
         }
     }
     */
    
    func randomNumber(randomQueue: DispatchQueue, temp: String, N: String, stateString: String) {
        
        var state: [Double] = []
        /*
        let temp = Double(tempString)!
        let N = Int(NString)!               */
        let temp = Double(temp)!
        let N = Int(N)!
        
        
        //      Java ex: double[] state = new double[N]; double[] test = state;
        // populate "numbers" with N = 1,000 1's (not sure if N will ever change or be user selectable)
        //
        for _ in 0..<N {
            state.append(-1)
        }
        
        
        // multiply -1 to random members of numbers array using large number "M" for effective randomizer
        let M = 10 * N // (not sure if N will ever change or be user selectable)
        
        // uncomment this for loop is for a "hot start" ...comment it out for a "cold start"
        /*
         // the Text() is not changing to this in content view :(
        self.initialStateTextString = "hot start"
         for _ in 0..<M {
            // sequence to choose random member of "numbers" array and multiply by -1
            let nthMember = Int.random(in: 0..<N)
            state[nthMember] *= -1
        }*/
        
        // are these two lines neccesary or isn't it already random enough from the for loop?
        //let shuffledNumbers = (numbers as NSArray).shuffled() as! [Int]
        //initialStateString = "\(shuffledNumbers)"
        var ES = ising.energyCalculation(S: state, N: N)
        
        
        // apply randomizer again to initial state
        var trialRandomFlip = state
        print("begin")
        
        // start random flipping
        //var start = DispatchTime.now() // starting time of the integration
        
        // formerly integrationQueue
        randomQueue.async{
            //DispatchQueue.concurrentPerform(iterations: Int(iterations), execute: { index in
            //DispatchQueue.concurrentPerform(iterations: 1, execute: { index in
                
                for _ in 0..<M {
                    
                    // plot initial state
                    // keep updating state with each iteration of the loop
                    // ////////////////////////////////////////////////////////////
                    // not a plot for now but update array at least? Nope doesn't work, nothing shows until randomNumber() finishes
                    //self.stateString = "\(state)"
                    //showCurrentState(stateString: stateString)
                    
                    // generate trial state by choosing 1 random electron at a time to flip
                    let nthMember = Int.random(in: 0..<N-1) // choose random electron in trial
                    trialRandomFlip[nthMember] *= -1      // flip chosen electron in trial
                    
                    // fix state according to probability
                    let ET = self.ising.energyCalculation(S: trialRandomFlip, N: N)
                    let p = exp((ES-ET)/self.ising.k*temp)
                    let randnum = Double.random(in: 0...1)
                    if (p >= randnum) {
                        
                        state = trialRandomFlip     // it changes the whole thing with every loop
                        ES = ET                     // ES stays as is if probability of trial is too low
                        
                        DispatchQueue.main.async{
                            //Update Display With Started Queue Thread On the Main Thread
                            self.stateString = "\(state)"
                              
                        }
                        
                    }
                    /*
                     DispatchQueue.main.async{
                     
                         //Update Display With Started Queue Thread On the Main Thread
                         self.outputText += "started index \(index)" + "\n"
                           
                     }
                     */
                    print(ES)
                    //wait(timeout: 5)
                    // delay by some microseconds
                    usleep(75000)
                    
                }
            print("it has finished")

            //integralArray.append(self.calculateMonteCarloIntegral(dimensions: 1, guesses: Int32(guesses), index: index))
        //})
        
        /*      This was not previously in randomQueue
             
             for _ in 0..<M {
                 
                 // plot initial state
                 // keep updating state with each iteration of the loop
                 // ////////////////////////////////////////////////////////////
                 // not a plot for now but update array at least? Nope doesn't work, nothing shows until randomNumber() finishes
                 stateString = "\(state)"
                 //showCurrentState(stateString: stateString)
                 
                 // generate trial state by choosing 1 random electron at a time to flip
                 let nthMember = Int.random(in: 0..<N-1) // choose random electron in trial
                 trialRandomFlip[nthMember] *= -1      // flip chosen electron in trial
                 
                 // fix state according to probability
                 let ET = ising.energyCalculation(S: trialRandomFlip, N: N)
                 let p = exp((ES-ET)/ising.k*temp)
                 let randnum = Double.random(in: 0...1)
                 if (p >= randnum) {
                     state = trialRandomFlip     // wait but it changes the whole thing with every loop?
                     ES = ET                     // ES stays as is if p < randnum
                 }
                 
                 print(ES)
                  
             }
             */
        
        
        //trialString = "\(trialRandomFlip)"
        
        // ex: 20x20 array
        // value [i,j] in 1D array = value[i + (j * number of elements in a row)]
        // 5,2 -> 5 + (2 * 20) = 45
        // [0, 1] in 20x20 matrix -> 20th element
                
        }
        
    }
    
}
