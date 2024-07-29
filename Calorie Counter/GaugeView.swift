//
//  GaugeView.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-07-28.
//

import UIKit

class GaugeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var outerColor : UIColor = UIColor.green
    private var innerColor : UIColor = UIColor.white
    
    private var outerRingWidth : CGFloat = 10
    private var innerRingWidth : CGFloat = 5
    
    func drawBackground(in rect: CGRect, context ctx: CGContext){
        outerColor.set()
        
        ctx.fillEllipse(in: rect)
        
        let innerRingBounds = rect.insetBy(dx: outerRingWidth, dy: outerRingWidth)
        innerColor.set()
        ctx.fillEllipse(in: innerRingBounds)
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        drawBackground(in: rect, context: ctx)
    }

}
