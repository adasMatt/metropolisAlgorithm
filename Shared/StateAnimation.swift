//
//  stateAnimation.swift
//  Monte Carlo Integration
//
//  Created by Matt Adas on 4/2/21.
//

import Foundation
import SwiftUI

class StateAnimationClass: NSObject, ObservableObject {

    // x values are simply "time step" (10N) and y values are each member of the array (1 to N)
    @Published var spinUpData = [(xPoint: Double, yPoint: Double)]()
    @Published var spinDownData = [(xPoint: Double, yPoint: Double)]()
    //@ObservedObject var presentState = FlipRandomState()
    
    //@Published var insideData = [(xPoint: Double, yPoint: Double)]()
    //@Published var outsideData = [(xPoint: Double, yPoint: Double)]()
    //@Published var totalGuessesString = ""
    //@Published var guessesString = ""
    //@Published var piString = ""
    @Published var xMin = 0.0
    @Published var xMax = 0.0
    @Published var yMin = 0.0
    @Published var yMax = 0.0
    //@Published var errorCalc = 0.0
    //@Published var functionCheck = 0.0
    
    // this is a core plot thing  and so far I will not use core plot
    //var plotDataModel: PlotDataClass? = nil
    //var actualValue = 0.0
    //var integralValue = 0.0
    //var guesses = 1
    //var totalGuesses = 0
    //var totalIntegral = 0.0
    //var radius = 1.0
    
    init(withData data: Bool){
        
        super.init()
        
        spinUpData = []
        spinDownData = []
        //insideData = []
        //outsideData = []
    }
    
    func plotState (state: [Double], n: Double) {
        
        //var numberOfGuesses = 0.0
        //var pointsInRadius = 0.0
        //var integral = 0.0
        var point = (xPoint: 0.0, yPoint: 0.0)
        
        // spinUpPoints, spinDownPoints?
        var spinUpPoints : [(xPoint: Double, yPoint: Double)] = []
        var spinDownPoints : [(xPoint: Double, yPoint: Double)] = []
        //var newInsidePoints : [(xPoint: Double, yPoint: Double)] = []
        //var newOutsidePoints : [(xPoint: Double, yPoint: Double)] = []
        
        /*    ///////////////////////////////////////////////////
         
         Need N x M "box" for plotting.
         Need blue if spin up (array member = -1), need red if spin down (array member = +1)
         x point is just where we are in the randomNumber() for loop 0...M.
         Get these points from each iteration of for loop within
         
         */
        
        point.xPoint = n // always just M from flipRandomState.randomNumber()
            // y points are 0...N-1
        
        // go through [state] and figure out spin UP and spin DOWN points
        for item in (0...state.count-1) {
            
            point.yPoint = Double(item)

            if state[item] == -1 {          // spin up
                spinUpPoints.append(point)
            }
            
            else {
                spinDownPoints.append(point)
            }
            
        }
         
        
        /*
        while numberOfGuesses < maxGuesses {
            
            /* Calculate 2 random values within the box */
            /* Determine the distance fro    m that point to the origin */
            /* If the distance is less than the unit radius count the point being within the Unit Circle */
            point.xPoint = Double.random(in: xMin...xMax)
            point.yPoint = Double.random(in: yMin...yMax)
            functionCheck = exp(-point.xPoint)
            
            // if inside the circle add to the number of points in the radius
            if((point.yPoint - functionCheck) < 0.0){
                pointsInRadius += 1.0
                newInsidePoints.append(point)
            }
            else { //if outside the circle do not add to the number of points in the radius
                newOutsidePoints.append(point)
            }
            
            numberOfGuesses += 1.0
            }*/
        
        //integral = Double(pointsInRadius)
        
        //Append the points to the arrays needed for the displays
        //Don't attempt to draw more than 250,000 points to keep the display updating speed reasonable.
        
        //if ((totalGuesses < 1000001) || (insideData.count == 0)){
        
        //    insideData.append(contentsOf: newInsidePoints)
        //    outsideData.append(contentsOf: newOutsidePoints)
        //}
        // actualValue = sinh(point.xPoint) - cosh(point.xPoint)
        //return integral
        }

/*
    /// calculate the value of π
    ///
    /// - Calculates the Value of π using Monte Carlo Integration
    ///
    /// - Parameter sender: Any
    func calculatePI()->(guesses: Int, errorCalc: Double, integral: Double )
    {
        
        
        
        var maxGuesses = 0.0
        let boundingBoxCalculator = BoundingBox() ///Instantiates Class needed to calculate the area of the bounding box.
        
        maxGuesses = Double(guesses)
        
        totalIntegral = totalIntegral + calculateMonteCarloIntegral(radius: radius, maxGuesses: maxGuesses)
        
        //totalGuesses = totalGuesses + guesses
        
        //totalGuessesString = "\(totalGuesses)"
        
        ///Calculates the value of π from the area of a unit circle
        
        integralValue = totalIntegral/Double(totalGuesses) * boundingBoxCalculator.calculateSurfaceArea(numberOfSides: 2, lengthOfSide1: (xMax-xMin), lengthOfSide2:(yMax-yMin), lengthOfSide3: 0.0)
        
        let myintegralvalue = integralValue
        let myfunctioncheck = functionCheck
        let truevalue = -exp(-xMax)-(-exp(-xMin))
        errorCalc = log10(abs((integralValue-truevalue)/truevalue))
        
        
        
//        print("\(truevalue)")
        print("\(guesses), \(errorCalc)")
//        print("\(guesses)")
//        print("\(integralValue)")
        
        
        piString = "\(integralValue)"
        
        return ((guesses: guesses, errorCalc: errorCalc, integral: integralValue))
                  
    }


    /// calculates the Monte Carlo Integral of a Circle
    ///
    /// - Parameters:
    ///   - radius: radius of circle
    ///   - maxGuesses: number of guesses to use in the calculaton
    /// - Returns: ratio of points inside to total guesses. Must mulitply by area of box in calling function
    func calculateMonteCarloIntegral(radius: Double, maxGuesses: Double) -> Double {
        
        var numberOfGuesses = 0.0
        var pointsInRadius = 0.0
        var integral = 0.0
        var point = (xPoint: 0.0, yPoint: 0.0)
        
        
        var newInsidePoints : [(xPoint: Double, yPoint: Double)] = []
        var newOutsidePoints : [(xPoint: Double, yPoint: Double)] = []
        
        
        while numberOfGuesses < maxGuesses {
            
            /* Calculate 2 random values within the box */
            /* Determine the distance fro    m that point to the origin */
            /* If the distance is less than the unit radius count the point being within the Unit Circle */
            point.xPoint = Double.random(in: xMin...xMax)
            point.yPoint = Double.random(in: yMin...yMax)
            
            functionCheck = exp(-point.xPoint)
            
            
            // if inside the circle add to the number of points in the radius
            if((point.yPoint - functionCheck) < 0.0){
                pointsInRadius += 1.0
                
                
                newInsidePoints.append(point)
               
            }
            else { //if outside the circle do not add to the number of points in the radius
                
                
                newOutsidePoints.append(point)

                
            }
            
            numberOfGuesses += 1.0
            
            
            }
        
        
        
        integral = Double(pointsInRadius)
        
        //Append the points to the arrays needed for the displays
        //Don't attempt to draw more than 250,000 points to keep the display updating speed reasonable.
        
        if ((totalGuesses < 1000001) || (insideData.count == 0)){
        
            insideData.append(contentsOf: newInsidePoints)
            outsideData.append(contentsOf: newOutsidePoints)
            
        }
        
        
//        actualValue = sinh(point.xPoint) - cosh(point.xPoint)
        
        
        return integral
        
        }*/
    
}
