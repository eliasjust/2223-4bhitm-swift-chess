//
//  BoardTapHandler.swift
//  chess
//
//  Created by BHITM01 on 12.04.23.
//

import Foundation
import UIKit
import SwiftUI



class BoardView: UIView {
    
    var viewmodel: ViewModel
    
    let boardSize: CGFloat = UIScreen.main.bounds.width * 0.9
    var squareSize: CGFloat { boardSize  / 8 }
    var offset:CGFloat  {(UIScreen.main.bounds.width - boardSize) / 2 }
    let whiteColor = UIColor.gray.cgColor
    let blackColor = UIColor.black.cgColor
    let activeColor = UIColor.yellow.cgColor
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func drawPieces() {
        //drawPiece(xPos: 4, yPos: 7, king: kingLayer)
        //view.transform =  CGAffineTransform(scaleX: 1.5, y: 1.5)
        //view.layer.setAffineTransform(CGAffineTransform(rotationAngle: 45))
        for (i, row) in viewmodel.board.enumerated() {
            for(j, piece) in row.enumerated() {
                
                if piece.piece != nil {
                    let pieceLayer = createPieceLayer(color: piece.color)
                    drawPiece(xPos:CGFloat(i), yPos: CGFloat(j), piece: pieceLayer)
                    layer.addSublayer(pieceLayer)
                    
                }
            }
        }
    }
    
    
    /*func makeUIView(context: Context) -> UIView {
     let view = UIView(frame: CGRect(x: offset, y: 0, width: boardSize, height: boardSize))
     let tapGestureRecognizer = UITapGestureRecognizer()
     tapGestureRecognizer.numberOfTapsRequired = 1
     tapGestureRecognizer.numberOfTouchesRequired = 1
     tapGestureRecognizer.addAction
     
     
     
     
     
     //let layerSize = view.layer.bounds.width
     //let transform = CGAffineTransform(translationX: view.layer.bounds.width / 2, y:
     
     drawBoard(view)
     drawPieces(view)
     return view
     }*/
    
    
    
    /* func updateUIView(_ uiView: UIView, context: Context) {
     
     
     }
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let fingerLocation  = touches.first?.location(in: self)
        print(fingerLocation ?? 0)
    }
    func drawPiece(xPos: Double,yPos: Double ,piece: CALayer) {
        
        piece.setAffineTransform(
            CGAffineTransform(translationX: squareSize * xPos + offset, y: squareSize * yPos )
        )
    }
    
    func createPieceLayer(color: Model.ChessColor?) -> CALayer {
        let pieceLayer = CAShapeLayer()
        let kingPath = UIBezierPath()
        
        
        kingPath.move(to: CGPoint(x: squareSize / 2, y: squareSize / 4))
        kingPath.addLine(to: CGPoint(x: squareSize / 2, y: 3 * squareSize / 4))
        kingPath.move(to: CGPoint(x: squareSize / 4, y: squareSize / 2))
        kingPath.addLine(to: CGPoint(x: 3 * squareSize / 4, y: squareSize / 2))
        
        pieceLayer.path = kingPath.cgPath
        pieceLayer.lineWidth = 3
        
        if color == .white {
            pieceLayer.strokeColor =
            UIColor.white.cgColor
            
        } else {
            pieceLayer.strokeColor =
            UIColor.green.cgColor
        }
        
        pieceLayer.fillColor = UIColor.clear.cgColor
        
        return pieceLayer
    }
    
    
    
    func drawBoard() {
        //king.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //king.transform = CGAffineTransform(scaleX: 2, y: 2)
        //king.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
        let  squareSize =  bounds.width / 8
        for row in 0..<8 {
            for col in 0..<8 {
                let squareLayer = CALayer()
                squareLayer.frame = CGRect(x: CGFloat(col) * squareSize + offset , y: CGFloat(row) * squareSize, width: squareSize, height: squareSize)
                
                
                if (row + col) % 2 == 0 {
                    squareLayer.backgroundColor = whiteColor
                } else {
                    squareLayer.backgroundColor = blackColor
                    
                }
                squareLayer.backgroundColor = viewmodel.fromPosition != nil ? activeColor : squareLayer.backgroundColor
                layer.addSublayer(squareLayer)
            }
        }
        
        
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        for view in subviews {
            if view.frame.contains(location) {
                print("Subview tapped")
                break;
            }
        }
    }
    
    
    
    init(viewModel:ViewModel) {
        self.viewmodel = viewModel
        super.init(frame: CGRect.zero
        )
        super.frame =  CGRect(x: offset, y: 0, width: boardSize, height: boardSize)
        
        drawBoard()
        drawPieces()
        
    }
    
    
    
    
    
}
