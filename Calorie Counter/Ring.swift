//
//  Ring.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-07-25.
//

import Foundation
import SwiftUI

struct Ring:Shape{
    static func percentageToAngle(percent:Float,startingAngle:Double) -> Double{
        return ((Double(percent)/(100*360))+startingAngle)
    }
    
    var currentPercent: Double
    var currentDegree: Double
    var toDraw: Bool
    
    var animationData: Double {
        get{
            currentPercent
        }
        set{
            currentPercent = newValue
        }
    }
    
    init(percentage: Double = 100,startAngle:Double = -90,toDraw: Bool = false){
        self.currentPercent = percentage
        self.currentDegree = startAngle
        self.toDraw = toDraw
    }
    
    func path(in rect:CGRect)-> Path{
        let width = rect.width
        let height = rect.height
        
        let diameter = min(height,width)
        let centerPoint = CGPoint(x: width/2, y:height/2 )
        let endAngle = Angle(degrees: Ring.percentageToAngle(percent: Float(self.currentPercent), startingAngle: self.currentDegree))
        return Path{ path in
            path.addArc(center: centerPoint, radius: diameter/2, startAngle: Angle(degrees: currentDegree), endAngle: endAngle, clockwise: self.toDraw)
            
        }
    }
}
