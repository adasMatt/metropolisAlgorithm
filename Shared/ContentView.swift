//
//  ContentView.swift
//  Shared
//
//  Created by Matthew Adas on 4/2/21.
//  Landau 15.4.1 Metropolis Algorithm Implementation
//  15.4.2 is just to make temp and N user selectable and note fluctuations in high temp vs low temp, spontaneous flipping in large N systems, flipping at equilibrium, ....see book for more

// for hot start option search "initialStateTextString = "hot start"" and remove un-comment the block until picker is added

// to work on animating spin flips:
// search "plot initial state"

// search "need a drawingView thingy someday"

//

import SwiftUI

struct ContentView: View {
    
    //@State var initialStateString = "[1, 1, 1, ...] (array generated when program runs)"
    //@State var stateString = "[1, 1, 1, ...] (array generated when program runs)"
    
    //@State var trialString = ""
    @State var energyString = " "
    @State var tempString = "100000000.0"
    @State var NString = "20"
    
    @ObservedObject var ising = IsingClass()
    @ObservedObject var flip = FlipRandomState()
    // copy pasting for drawing view part just for now, will need major changes
    //@ObservedObject var monteCarlo = MonteCarloCircle(withData: true)
    //@ObservedObject var monteCarlo = MonteCarloEToMinusX(withData: true)
    @ObservedObject var stateAnimate = StateAnimationClass(withData: true)
    
    var body: some View {
        HStack {
            
            VStack {
                
                 
                Text("temp")
                    .padding(.top)
                    .padding(.bottom, 0)
                TextField("temperature", text: $tempString)
                    .padding(.horizontal)
                    .frame(width: 100)
                    .padding(.top, 0)
                    .padding(.bottom, 30)
                
                Text("total electrons (N)")
                    .padding(.bottom, 0)
                TextField("number of electrons", text: $NString)
                    .padding(.horizontal)
                    .frame(width: 100)
                    .padding(.top, 0)
                    .padding(.bottom, 30)
                
                // button
                Button("Generate random states", action: startTheFlipping)
                    .padding()
                
            }
        
            // need a drawingView thingy someday
             //
            VStack {
                drawingView(redLayer: $stateAnimate.spinUpData, blueLayer: $stateAnimate.spinDownData, xMin:$stateAnimate.xMin, xMax:$stateAnimate.xMax,yMin:$stateAnimate.yMin, yMax:$stateAnimate.yMax)
                     .padding()
                     .aspectRatio(1, contentMode: .fit)
                     .drawingGroup()
                 // Stop the window shrinking to zero.
                 Spacer()
                
                VStack {
                    Text(flip.initialStateTextString) // need a picker for cold or hot start
                        .padding(.top)
                        .padding(.bottom, 0)
                    TextEditor(text: $flip.stateString)
                    
                }
            
            }
        }
    }
    
    func startTheFlipping() {
        
        //Create a Queue for the Calculation
        //We do this here so we can make testing easier.
        let randomQueue = DispatchQueue.init(label: "randomQueue", qos: .userInitiated, attributes: .concurrent)
         
        //myIntegrator.integration(iterations: iterations, guesses: guesses, integrationQueue: integrationQueue )
        
        stateAnimate.xMin = 0.0
        stateAnimate.xMax = 10.0*Double(NString)!
        stateAnimate.yMin = 0.0
        stateAnimate.yMax = Double(NString)!
        
        flip.randomNumber(randomQueue: randomQueue, tempStr: tempString, NStr: NString, stateString: flip.stateString )
        
                 
    }

    /*
     // might be what I need to modify for drawingView in this project
     func calculateMonteCarloIntegral() -> Double {
         
         var errorCalc = 0.0
         
         monteCarlo.calculateIntegral() // I replaced calculatePI() in class MonteCarloEToMinusX
         monteCarlo.xMin = 0.0
         monteCarlo.xMax = 1.0
         monteCarlo.yMin = 0.0
         monteCarlo.yMax = 1.0
         
         totalGuessString = monteCarlo.totalGuessesString
         
         integralString =  monteCarlo.integralString
         
         // determine how the error changes as a function of N
         let e_MinusXIntegral = monteCarlo.pi
         let actualEMinus_xIntegral = -exp(-1.0) + exp(0.0)
         
         var numerator = e_MinusXIntegral - actualEMinus_xIntegral
         if(numerator == 0.0) {numerator = 1.0E-16}
         
         errorCalc = log10(abs(numerator)/actualEMinus_xIntegral)
     
         error = "\(errorCalc)"
         
         return errorCalc
         
     }
     */
    
    
    
    /*
     func randomNumber() {
        
        var state: [Double] = []
        let temp = Double(tempString)!
        let N = Int(NString)!
        
        //      Java ex: double[] state = new double[N]; double[] test = state;
        // populate "numbers" with N = 1,000 1's (not sure if N will ever change or be user selectable)
        //
        for _ in 1..<N {
            state.append(-1)
        }
        
        
        // multiply -1 to random members of numbers array using large number "M" for effective randomizer
        let M = 10 * N // (not sure if N will ever change or be user selectable)
        
        // uncomment this for loop is for a "hot start" ...comment it out for a "cold start"
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
        var ES = ising.energyCalculation(S: state, N: N)
        
        
        // apply randomizer again to initial state
        var trialRandomFlip = state
        print("begin")
        for _ in 1..<M {
            
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
        //trialString = "\(trialRandomFlip)"
    }       */
    
}








// ////////////////////////////////////////////////// //
// /////////////// stuff to not touch /////////////// //
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
