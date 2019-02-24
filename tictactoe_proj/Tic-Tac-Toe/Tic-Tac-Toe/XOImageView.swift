//
//  XOImageView.swift
//  Tic-Tac-Toe
//
//  Created by Samantha Rey on 7/31/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

class XOImageView: UIImageView {
    
    var initialx: CGFloat = 0.0
    var initialy: CGFloat = 0.0
    
    var type: String = ""
    
    //
    // MARK: - Initialization
    //
    
    init (frame : CGRect, type: String) {
        super.init(frame : frame)
        
        initialx = frame.origin.x
        initialy = frame.origin.y
        
        self.type = type
        
        self.image = UIImage(named: type)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    
    /*
    func dragXO(_ sender: UIPanGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began) {
            let recognizedpoint = sender.location(in: self)
            print("locationInview : \(recognizedpoint)")
            
            if let view = sender.view {
                // Set the view's center to the new position
                view.center = CGPoint(x: view.center.x + recognizedpoint.x - 57,
                                      y: view.center.y + recognizedpoint.y - 57)
            }
            
            //print("x translation = \(translation.x)")
            //print("y translation = \(translation.y)")
            
            // Reset the translation back to zero, so we are dealing in offsets
            sender.setTranslation(CGPoint.zero, in: self)
        }
        else if (sender.state == UIGestureRecognizerState.changed) {
            //print("CHANGED")
            let translation = sender.translation(in: self)
            
            if let view = sender.view {
                // Set the view's center to the new position
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
                
                print("x center = \(view.center.x)")
                print("y center = \(view.center.y)")
            }
            
            let recognizedpoint = sender.location(in: self)
            print("locationInview : \(recognizedpoint)")
            
            // Reset the translation back to zero, so we are dealing in offsets
            sender.setTranslation(CGPoint.zero, in: self)
        }
        else if (sender.state == UIGestureRecognizerState.ended) {
            print("END")
            
            if let view = sender.view {
                // Set the view's center to the new position
                if(view.center.y < 200) {
                    view.frame.origin.x = initialx
                    view.frame.origin.y = initialy
                }
            }
        }
    }
    */

}
