//
//  ViewController.swift
//  Tic-Tac-Toe
//
//  Created by Samantha Rey on 7/30/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

// - Attribution: https://www.youtube.com/watch?v=worclOeTALw Correct/Wrong XO Placement sounds
// - Attribution: https://www.youtube.com/watch?v=-6g48Eb0Ris Pickup Sound (facebook messenger refresh sound. I like this sound a lot)
// - Attribution: Bee and Puppycat, win jingle. I paid for this a while back I just like the whimsical sound
// - Attribution: https://medium.com/ios-os-x-development/uiview-animation-in-swift-3-2b499abb58c5 General help learning to use the UIView animations

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    //
    // MARK: - Properties
    //
    
    // MARK: Instance Variables
    var boardWidth: CGFloat = 0
    var pieceWidth: CGFloat = 0
    
    var turn: String = "x"
    
    var currentX: XOImageView?
    var currentO: XOImageView?
    
    var soundEffect: AVAudioPlayer!
    
    var spaces: [UIView] = []
    var pieces: [XOImageView] = []
    var winLine: DrawLine? = nil
    
    
    // MARK: Outlet Properties
    @IBOutlet weak var board: UIImageView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    //
    // MARK: - Default methods
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding actions for the buttons
        aboutButton.addTarget(self, action: #selector(aboutTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        aboutView.center.y = -400
        
        boardWidth = board.frame.size.width
        pieceWidth = boardWidth/3
        
        //Adding the Tic-tac-toe space UIViews
        for i in 0..<3 {
            for j in 0..<3 {
                let iFloat = CGFloat(i)
                let jFloat = CGFloat(j)
                
                let newSpace: UIView = UIView(frame: CGRect(x: jFloat*pieceWidth, y: iFloat*pieceWidth, width: pieceWidth, height: pieceWidth))
                newSpace.tag = 0
                newSpace.alpha = 0
                
                spaces.append(newSpace)
                board.addSubview(newSpace)
            }
        }
        
        currentX = addPiece(type: "x")
        currentO = addPiece(type: "o")
        newGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // MARK: - Custom Methods
    //
    
    //Play the sound at the given path
    func playSound(path: String) {
        let path = Bundle.main.path(forResource: path, ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            self.soundEffect = sound
            sound.play()
        } catch {
            print("ERROR: COULD NOT PLAY SOUND!")
        }
    }
    
    //Detect Whether the game has ended and return the corresponding result int that corresponds to the type of outcome
    func isEnd() -> Int {
        //Is there a horizontal win?
        for i in 0..<3 {
            if(spaces[3*i].tag == spaces[3*i + 1].tag &&
                spaces[3*i].tag == spaces[3*i + 2].tag &&
                spaces[3*i].tag > 0) {
                let tag = spaces[3*i].tag
                let line = DrawLine(frame: CGRect(x: board.frame.origin.x, y: board.frame.origin.y,
                                                  width: boardWidth, height: boardWidth),
                                    start: CGPoint(x: 0, y: spaces[3*i].center.y),
                                    end: CGPoint(x: boardWidth, y: spaces[3*i].center.y),
                                    type: tag)
                self.view.addSubview(line)
                winLine = line
                return tag
            }
        }
        
        //Is there a vertical win?
        for j in 0..<3 {
            if(spaces[j].tag == spaces[3+j].tag &&
                spaces[j].tag == spaces[6+j].tag &&
                spaces[j].tag > 0) {
                let tag = spaces[j].tag
                let line = DrawLine(frame: CGRect(x: board.frame.origin.x, y: board.frame.origin.y,
                                                  width: boardWidth, height: boardWidth),
                                    start: CGPoint(x: spaces[j].center.x, y: 0),
                                    end: CGPoint(x: spaces[j].center.x, y: boardWidth),
                                    type: tag)
                self.view.addSubview(line)
                winLine = line
                return tag
            }
        }
        
        //Is there a forward diagonal win?
        if(spaces[0].tag == spaces[4].tag &&
            spaces[0].tag == spaces[8].tag &&
            spaces[0].tag > 0) {
            let tag = spaces[0].tag
            let line = DrawLine(frame: CGRect(x: board.frame.origin.x, y: board.frame.origin.y,
                                              width: boardWidth, height: boardWidth),
                                start: CGPoint(x: 0, y: 0),
                                end: CGPoint(x: boardWidth, y: boardWidth),
                                type: tag)
            self.view.addSubview(line)
            winLine = line
            return tag
        }
        
        //Is there a backwards diagonal win?
        if(spaces[2].tag == spaces[4].tag &&
            spaces[2].tag == spaces[6].tag &&
            spaces[2].tag > 0) {
            let tag = spaces[2].tag
            let line = DrawLine(frame: CGRect(x: board.frame.origin.x, y: board.frame.origin.y,
                                              width: boardWidth, height: boardWidth),
                                start: CGPoint(x: boardWidth, y: 0),
                                end: CGPoint(x: 0, y: boardWidth),
                                type: tag)
            self.view.addSubview(line)
            winLine = line
            return tag
        }
        
        var k = 0
        
        //Is the game at a draw?
        for space in spaces {
            if(space.tag == 0) {
                k = -1
            }
        }
        
        return k
    }
    
    //Check if a point is within the bounds of a frame
    func inBounds(place: CGPoint, viewframe: CGRect) -> Bool {
        let boardLeft = viewframe.origin.x
        let boardTop = viewframe.origin.y
        let boardRight = boardLeft + viewframe.width
        let boardBottom = boardTop + viewframe.height
        
        return ((place.x >= boardLeft && place.x <= boardRight) &&
                (place.y >= boardTop && place.y <= boardBottom))
    }
    
    //Add a new XO piece in the initial spot
    func addPiece(type: String) -> XOImageView {
        
        var x: CGFloat = 25
        
        if(type == "o") {
            x = UIScreen.main.bounds.width - pieceWidth - 25
        }
        
        let piece: XOImageView = XOImageView(frame: CGRect(x: x, y: 500, width: boardWidth/3, height: boardWidth/3), type: type)
        addDrag(piece)
        self.view.addSubview(piece)
        
        return piece
    }
    
    //Control logic for switching players between turns
    func switchTurns() {
        if (turn == "x") {
            currentX?.alpha = 0.5
            currentX?.isUserInteractionEnabled = false
            currentO?.alpha = 1
            if let opiece = currentO{
                // - Attribution https://stackoverflow.com/questions/31320819/scale-uibutton-animation-swift for help scaling and unscaling the XO pieces
                UIView.animate(withDuration: 0.3,
                            animations: {
                            // NOTE: I thought 1.6x scale looked better than 2x scale
                            opiece.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                },
                            completion: { _ in
                                UIView.animate(withDuration: 0.4) {
                                    opiece.transform = CGAffineTransform.identity
                                }
                })
            }
            currentO?.isUserInteractionEnabled = true
            turn = "o"
        }
        else {
            currentO?.alpha = 0.5
            currentO?.isUserInteractionEnabled = false
            currentX?.alpha = 1
            if let xpiece = currentX{
                UIView.animate(withDuration: 0.3,
                               animations: {
                                xpiece.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                },
                               completion: { _ in
                                UIView.animate(withDuration: 0.4) {
                                    xpiece.transform = CGAffineTransform.identity
                                }
                })
            }

            currentX?.isUserInteractionEnabled = true
            turn = "x"
        }
    }
    
    //Control logic for starting a new game
    func newGame() {
        for piece in pieces {
            if(piece.type == "x") {
                UIView.animate(withDuration: 1, animations: {
                    piece.center.x = 500
                }, completion: {_ in
                    piece.removeFromSuperview()
                })
            }
            else {
                UIView.animate(withDuration: 1, animations: {
                    piece.center.x = -300
                }, completion: {_ in
                    piece.removeFromSuperview()
                })
            }
        }
        if let line = winLine {
            UIView.animate(withDuration: 0.5, animations: {
                line.alpha = 0
            }, completion: {_ in
                line.removeFromSuperview()
                self.winLine = nil
            })
        }
        for space in spaces {
            space.tag = 0
        }
        turn = "x"
        currentX?.isUserInteractionEnabled = true
        currentX?.alpha = 1
        if let xpiece = currentX{
            UIView.animate(withDuration: 0.3, delay: 0.8,
                           animations: {
                            xpiece.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.4) {
                                xpiece.transform = CGAffineTransform.identity
                            }
            })
        }
        currentO?.isUserInteractionEnabled = false
        currentO?.alpha = 0.5
    }
    
    //Add drag action to a UIView
    func addDrag(_ view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.drag(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        view.isUserInteractionEnabled = true
    }
    
    //Control logic for dragging XOpieces
    func drag(_ sender: UIPanGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began) {
            playSound(path: "sounds/pickup.mp3")

            
            if let view = sender.view {
                // Set the view's center to the new position
                let recognizedpoint = sender.location(in: sender.view)
                //print("locationInview : \(recognizedpoint)")
                
                view.center = CGPoint(x: view.center.x + recognizedpoint.x - (pieceWidth/2),
                                      y: view.center.y + recognizedpoint.y - (pieceWidth/2))
                
                //print("x translation = \(translation.x)")
                //print("y translation = \(translation.y)")
                
                // Reset the translation back to zero, so we are dealing in offsets
                sender.setTranslation(CGPoint.zero, in: sender.view)
            }
        }
        else if (sender.state == UIGestureRecognizerState.changed) {
            //print("CHANGED")
            if let view = sender.view {
                let translation = sender.translation(in: sender.view)
                
                // Set the view's center to the new position
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
                
                //let recognizedpoint = sender.location(in: sender.view)
                //print("locationInview : \(recognizedpoint)")
                
                // Reset the translation back to zero, so we are dealing in offsets
                sender.setTranslation(CGPoint.zero, in: sender.view)
            }
            
        }
        else if (sender.state == UIGestureRecognizerState.ended) {
            if let view = sender.view {
                // Set the view's center to the new position
                if let xoview = view as? XOImageView {
                    var placed: Bool = false
                    
                    for space in spaces {
                        let viewframe = CGRect(x: space.frame.origin.x + board.frame.origin.x,
                            y: space.frame.origin.y + board.frame.origin.y, width: pieceWidth,
                            height: pieceWidth)
                        let viewcenter = CGPoint(x: space.center.x + board.frame.origin.x,
                                                 y: space.center.y + board.frame.origin.y)
                        if(inBounds(place: xoview.center, viewframe: viewframe)) {
                            if(space.tag == 0) {
                                xoview.center = viewcenter
                                if(turn == "x") {
                                    space.tag = 100
                                    xoview.isUserInteractionEnabled = false
                                    currentX = addPiece(type: "x")
                                }
                                else {
                                    space.tag = 200
                                    xoview.isUserInteractionEnabled = false
                                    currentO = addPiece(type: "o")
                                }
                                pieces.append(xoview)
                                placed = true
                                
                                let k = isEnd()
                                var message = ""
                                if(k == 100) {
                                    message = "X Wins!"
                                }
                                else if(k == 200) {
                                    message = "O Wins!"
                                }
                                else if(k == 0) {
                                    message = "It's a Draw"
                                }
                                
                                if(k == -1) {
                                    playSound(path: "sounds/correct.mp3")
                                    switchTurns()
                                }
                                else {
                                    if(k != 0) {
                                        playSound(path: "sounds/win.mp3")
                                    }
                                    let alert = UIAlertController(title: "Game Over",
                                                                  message: message,
                                        preferredStyle: .alert)
                                    
                                    let action = UIAlertAction(title: "New Game", style: .default, handler: {action in self.newGame()})
                                    
                                    alert.addAction(action)
                                    present(alert, animated: true, completion: nil)
                                    //Do popup
                                }
                            }
                            
                        }
                    }
                    
                    if(!placed) {
                        playSound(path: "sounds/wrong.mp3")
                        UIView.animate(withDuration: 0.1, animations: {
                            xoview.frame.origin.x = xoview.initialx
                            xoview.frame.origin.y = xoview.initialy
                        }, completion: nil)
                    }
                }
            }
        }
    }
    
    //Control function for pressing the about Button
    func aboutTapped(sender: UIButton!) {
        // - Attribution: https://stackoverflow.com/questions/38937051/how-to-programmatically-set-view-to-the-front-back bringing about View to the front so that, even though  x,o pieces are constantly being added, they're behind the aboutView
        self.view.bringSubview(toFront: aboutView)
        UIView.animate(withDuration: 0.4, animations: {
            self.aboutView.frame.origin.y = 20
        }, completion: nil)
    }
    
    //Control funciton for pressing the back Button on the about view
    func backTapped(sender: UIButton!) {
        UIView.animate(withDuration: 0.4, animations: {
            self.aboutView.center.y = 1200
        }, completion: {_ in self.aboutView.center.y = -400})
    }


}

