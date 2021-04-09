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
// search "not a plot for now but update array at least?"
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
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(flip.initialStateTextString) // need a picker for cold or hot start
                .padding(.top)
                .padding(.bottom, 0)
            TextEditor(text: $flip.stateString) // how do I show stateString as randomNumber() and ising.energyCalculation() are calculating?
             
            /*
             Text("randomly flipped state")
                 .padding(.top)
                 .padding(.bottom, 0)
             TextEditor(text: $trialString)
             */
            
            // energy printout?
        }
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
            
            // need a drawingView thingy someday
            /*
             drawingView(redLayer:$monteCarlo.insideData, blueLayer: $monteCarlo.outsideData)
                 .padding()
                 .aspectRatio(1, contentMode: .fit)
                 .drawingGroup()
             // Stop the window shrinking to zero.
             Spacer()
             */
            
            
            // button
            Button("Generate random states", action: startTheFlipping)
                .padding()
        }
        
            
        
    }
    
    //
    func startTheFlipping() {
                 
         //let guesses = Int(myIntegrator.numberOfGuessesString) ?? 1000
         
         //let iterations = Int(myIntegrator.numberOfIterationsString) ?? 10
         
         //Create a Queue for the Calculation
         //We do this here so we can make testing easier.
         let randomQueue = DispatchQueue.init(label: "randomQueue", qos: .userInitiated, attributes: .concurrent)
         
                 
             
         //myIntegrator.integration(iterations: iterations, guesses: guesses, integrationQueue: integrationQueue )
        flip.randomNumber(randomQueue: randomQueue, tempStr: tempString, NStr: NString, stateString: flip.stateString )
                 
    }

    
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
