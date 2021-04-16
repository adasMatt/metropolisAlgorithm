//
//  DrawingView.swift
//  Monte Carlo Integration
//
//  Created by Jeff Terry on 12/31/20.
//

import SwiftUI

struct drawingView: View {
    
    @Binding var redLayer : [(xPoint: Double, yPoint: Double)]
    @Binding var blueLayer : [(xPoint: Double, yPoint: Double)]
    @Binding var xMin : Double
    @Binding var xMax : Double
    @Binding var yMin : Double
    @Binding var yMax : Double
    
    var body: some View {
    
        
        ZStack{
        
            drawIntegral(drawingPoints: redLayer, xMin: xMin,xMax: xMax, yMin: yMin, yMax: yMax )
                .stroke(Color.red)
            
            drawIntegral(drawingPoints: blueLayer, xMin: xMin,xMax: xMax, yMin: yMin, yMax: yMax )
                .stroke(Color.blue)
        }
        .background(Color.white)
        .aspectRatio(1, contentMode: .fill)
        
    }
}

//struct DrawingView_Previews: PreviewProvider {
//
//    @State static var redLayer : [(xPoint: Double, yPoint: Double)] = [(-0.5, 0.5), (0.5, 0.5), (0.0, 0.0), (0.0, 1.0)]
//    @State static var blueLayer : [(xPoint: Double, yPoint: Double)] = [(-0.5, -0.5), (0.5, -0.5), (0.9, 0.0)]
//
//    static var previews: some View {
//
//
//        drawingView(redLayer: $redLayer, blueLayer: $blueLayer)
//            .aspectRatio(1, contentMode: .fill)
//            //.drawingGroup()
//
//    }
//}


struct drawIntegral: Shape {
    
    let smoothness : CGFloat = 1.0
    var drawingPoints: [(xPoint: Double, yPoint: Double)]  ///Array of tuples
    var xMin : Double
    var xMax : Double
    var yMin : Double
    var yMax : Double
    
    func path(in rect: CGRect) -> Path {
        
        // draw from the center of our rectangle
        // let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        // let scale = rect.width
        
        // Create the Path for the display
        
        var path = Path()
        for item in drawingPoints {
                
            let y = -(item.yPoint-yMin)/(yMax-yMin)*Double(rect.height)+Double(rect.height)
            let x = (item.xPoint-xMin)/(xMax-xMin)*Double(rect.width)
            
            // path.addRect(CGRect(x: item.xPoint*Double(scale)+Double(center.x), y: item.yPoint*Double(scale)+Double(center.y), width: 1.0 , height: 1.0))
            path.addRect(CGRect(x: x, y: y, width: 1.0 , height: 1.0))
                       
        }


        return (path)
    }
}

/*
struct drawIntegral: Shape {
    
    let smoothness : CGFloat = 1.0
    var drawingPoints: [(xPoint: Double, yPoint: Double)]  ///Array of tuples
    var xMin : Double
    var xMax : Double
    var yMin : Double
    var yMax : Double
    
    func path(in rect: CGRect) -> Path {
        
        // draw from the center of our rectangle
        // let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        // let scale = rect.width
        
        // Create the Path for the display
        
        var path = Path()
        for item in drawingPoints {
            
        let y = -(item.yPoint-yMin)/(yMax-yMin)*Double(rect.height)+Double(rect.height)
        let x = (item.xPoint-xMin)/(xMax-xMin)*Double(rect.width)
            
//            path.addRect(CGRect(x: item.xPoint*Double(scale)+Double(center.x), y: item.yPoint*Double(scale)+Double(center.y), width: 1.0 , height: 1.0))
            path.addRect(CGRect(x: x, y: y, width: 1.0 , height: 1.0))
                       
        }


        return (path)
    }
}
*/
