//
//  ContentView.swift
//  Shared
//
//  Created by Matthew Adas on 4/2/21.
//  Landau 15.4.1 Metropolis Algorithm Implementation
//  15.4.2 is just to make temp and N user selectable and note fluctuations in high temp vs low temp, spontaneous flipping in large N systems, flipping at equilibrium, ....see book for more

// for hot start option search "initialStateTextString = "hot start"" and remove un-comment the block until picker is added





// //////////////////////////////////////////////
// search: I removed this line is that bad?
// ////////////////////////////////////////////

import SwiftUI

struct ContentView: View {
    
    //@State var initialStateString = "[1, 1, 1, ...] (array generated when program runs)"
    //@State var stateString = "[1, 1, 1, ...] (array generated when program runs)"
    
    //@State var energyString = " "
    @State var tempString = "1.0"
    @State var numElectronString = "20"
    
    //@ObservedObject var ising = IsingClass() // actually not using IsingClass() here
    @ObservedObject var flip = FlipRandomState()
    @ObservedObject var stateAnimation = StateAnimationClass(withData: true)
    
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
                TextField("number of electrons", text: $numElectronString)
                    .padding(.horizontal)
                    .frame(width: 100)
                    .padding(.top, 0)
                    .padding(.bottom, 30)
                
                // button
                Button("Generate random states", action: startTheFlipping)
                    .padding()
                Button("get", action: printValue)
                    .padding()
                
            }
        
            VStack {
                drawingView(redLayer: $stateAnimation.spinUpData, blueLayer: $stateAnimation.spinDownData, xMin:$stateAnimation.xMin, xMax:$stateAnimation.xMax, yMin:$stateAnimation.yMin, yMax:$stateAnimation.yMax)
                    //.fixedSize(horizontal: true, vertical: true)
                    //.frame(width: 200.0, height: 20.0)
                    
                    // I removed this line is that bad?
                    //.frame(minWidth: 400, idealWidth: 1800, maxWidth: 2800, minHeight: 400, idealHeight: 1800, maxHeight: 2800)
                    .padding()
                    .aspectRatio(1, contentMode: .fit)
                    .drawingGroup()
                    
                    
                 // Stop the window shrinking to zero.
                 Spacer()
                
            }
        }
    }
    
    func printValue() {
        
        for item in stateAnimation.spinUpData {
            print(item)
        }
    }
    
    func startTheFlipping() {
        
        stateAnimation.spinDownData = []
        stateAnimation.spinUpData = []
        
        //Create a Queue for the Calculation
        //We do this here so we can make testing easier.
        let randomQueue = DispatchQueue.init(label: "randomQueue", qos: .userInitiated, attributes: .concurrent)
        
        stateAnimation.xMin = 0.0
        //stateAnimation.xMax = 10.0*Double(numElectronString)! // if I change this, I need to change the following in flipRandomState: let M = 800*N
        stateAnimation.xMax = 250.0
        stateAnimation.yMin = 0.0
        stateAnimation.yMax = Double(numElectronString)!
        
        
        flip.stateAnimate = self.stateAnimation
        flip.randomNumber(randomQueue: randomQueue, tempStr: tempString, NStr: numElectronString )
        
    }
    
}



// ////////////////////////////////////////////////// //
// /////////////// stuff to not touch /////////////// //
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
