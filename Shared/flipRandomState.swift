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
    @ObservedObject var stateAnimate = StateAnimationClass(withData: true)
    
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
    
    func randomNumber(randomQueue: DispatchQueue, tempStr: String, NStr: String, stateString: String) -> Double {
        
        var state: [Double] = []
        let temp = Double(tempStr)!
        let N = Int(NStr)!
        var box = 0.0
        
        //      Java ex: double[] state = new double[N]; double[] test = state;
        // populate "numbers" with N = 1,000 1's (not sure if N will ever change or be user selectable)
        //
        for _ in 0..<N {
            state.append(-1)
        }
        
        // multiply -1 to random members of numbers array using large number "M" for effective randomizer
        let M = 10 * N      // (not sure if N will ever change or be user selectable)
        
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
        
        // Start random flipping
        // var start = DispatchTime.now() // starting time of the integration
        
        randomQueue.async{          // formerly integrationQueue
            //DispatchQueue.concurrentPerform(iterations: Int(iterations), execute: { index in
            //DispatchQueue.concurrentPerform(iterations: 1, execute: { index in
                for n in 0..<M {
                    
                    // plot initial state?
                    // keep updating state with each iteration of the loop
                    // ////////////////////////////////////////////////////////////
                    // not a plot for now but update array at least
                    // plotState() takes [state] and uses it to make y-points, n is the x-point for all of those y-points :)
                    box = self.stateAnimate.plotState(state: state, n: Double(n))
                    
                    // generate trial state by choosing 1 random electron at a time to flip
                    let nthMember = Int.random(in: 0..<N) // choose random electron in trial
                    trialRandomFlip[nthMember] *= -1      // flip chosen electron in trial
                    
                    // fix state according to probability
                    let ET = self.ising.energyCalculation(S: trialRandomFlip, N: N)
                    
                    let p = exp((ES-ET)/(self.ising.k*temp))
                    //print("p = ",p)
                    let randnum = Double.random(in: 0...1)
                    
                    if (p >= randnum) {
                        //print("rand =", randnum, "p =", p)
                        state = trialRandomFlip     // it changes the whole thing with every loop
                        ES = ET                     // ES stays as is if probability of trial is too low
                        
                        DispatchQueue.main.async{
                            //Update Display With Started Queue Thread On the Main Thread
                            self.stateString = "\(state)"
                        }
                        //print(ES)
                    }
                    /*
                     DispatchQueue.main.async{
                         //Update Display With Started Queue Thread On the Main Thread
                         self.outputText += "started index \(index)" + "\n"
                     }
                     */
                    //print(ES)
                    //wait(timeout: 5)
                    // delay by some microseconds
                    usleep(7500) // add a zero for a more readable speed at lower N
                    
                }
            print("it has finished, state at equilibrium: \(state)")
            
            // average domain size
            // count + in a row, count - in a row, average size
            // probably just make it into an observable object class right
            
            var counted = 0
            var domainSizesArr: [Int] = []
            
            var modArr = state         // modArr probably needs to start empty actually, and set equal to state either after or during the randomNumber function
            
            var lenModArr = modArr.count    // changes each time something is counted in modArr/finalArray ...yea idk what this will need to be changed to within the class yet

            //func countPosFunc(funcArr: [Int]) -> (Int, [Int]) {
            func countPosFunc(funcArr: [Double]) -> [Double] {
                counted = 0                     // reset to 0 each time the function runs
                let N = funcArr.count
                var modFinalArray: [Double] = []   // I mean I want to throw it out each time so I can generate a new one each time maybe?

                for item in (0...N-1) {
                    if funcArr[item] == 1 {
                        counted += 1
                        //totalCount += 1         // add to global variable totalCount
                    }
                    else {break}                // break the for loop and return counted instances of consecutive -1
                }

                // discard the array members already examined?
                
                if counted == N {return [0]} // do not continue reducing modArray if it is on it's final domain
                for item in (counted...N-1) {
                    modFinalArray.append(funcArr[item]) //?
                }
                lenModArr = modFinalArray.count
                //print(modFinalArray)
                return modFinalArray
            }

            func countNegFunc(funcArr: [Double]) -> [Double] {
                counted = 0
                let N = funcArr.count
                var modFinalArray: [Double] = []

                for item in (0...N-1) {
                    if funcArr[item] == -1 {
                        counted += 1
                        //totalCount += 1
                    }
                    else {break}
                }
                
                if counted == N {return [0]}
                for item in (counted...N-1){
                    modFinalArray.append(funcArr[item])
                }
                lenModArr = modFinalArray.count
                //print(modFinalArray)
                return modFinalArray
            }

            while lenModArr > 1 { // problem if I have a lonely spin at the very end, or maybe not since I'm typically working with large N anyway? Can't I afford to lose that last lonely spin?
                //print(lenModArr)
                modArr = countNegFunc(funcArr: modArr)
                if counted > 0 {domainSizesArr.append(counted)} //  obviously I only want to append non-zero size domains
                //print(modArr, counted)
                //print(lenModArr)
                modArr = countPosFunc(funcArr: modArr)
                if counted > 0 {domainSizesArr.append(counted)}
                //print(modArr, counted, totalCount)
                
            }
            print("sizes of domains: \(domainSizesArr)")
            
            // avg domain size
            // sum Of domains is just the length of the state array of course
            // is there still an issue here carried over from the possible missing lonely spin?
            let lengthOfDomainSizeArr = domainSizesArr.count
            let sumOfDomain = state.count
            let avgDomain = sumOfDomain / lengthOfDomainSizeArr
            
            print("avg domain size: \(avgDomain)")
            
            
            //integralArray.append(self.calculateMonteCarloIntegral(dimensions: 1, guesses: Int32(guesses), index: index))
        //})
          
        // ex: 20x20 array
        // value [i,j] in 1D array = value[i + (j * number of elements in a row)]
        // 5,2 -> 5 + (2 * 20) = 45
        // [0, 1] in 20x20 matrix -> 20th element
                
        }
        return box
    }
    
}
