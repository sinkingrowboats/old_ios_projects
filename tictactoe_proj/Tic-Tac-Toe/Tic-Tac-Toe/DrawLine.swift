//
//  DrawLine.swift
//  Tic-Tac-Toe
//
//  Created by Samantha Rey on 8/2/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

class DrawLine: UIView {
    
    var start: CGPoint?
    var end: CGPoint?
    
    var color = UIColor.white
    
    init(frame: CGRect, start: CGPoint, end: CGPoint, type: Int) {
        super.init(frame: frame)
        if(type == 100) {
            color = UIColor(red: 222/255, green: 193/255, blue: 138/255, alpha: 1)
        }
        else {
            color = UIColor(red: 147/255, green: 56/255, blue: 44/255, alpha: 1)
        }
        
        // - Attribution: https://stackoverflow.com/questions/11318987/black-background-when-overriding-drawrect-in-uiscrollview couldn't figure out how to remove black background from the line graphic drawn during a winning game
        self.isOpaque = false
        self.start = start
        self.end = end
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // - Attribution: https://stackoverflow.com/questions/31569051/how-to-draw-a-line-in-the-simplest-way-in-swift Drawing the winning line for the tic-tac-toe board
        let path = UIBezierPath()
        path.lineWidth = 4
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        if let startwrap = start {
            path.move(to: startwrap)
        }
        
        //add a point to the path at the end of the stroke
        if let endwrap = end {
            path.addLine(to: endwrap)
        }
        
        //set the stroke color
        color.setStroke()
        
        //draw the stroke
        path.stroke()
    }

}
