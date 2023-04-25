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
    var offset:CGFloat  = 0
    let whiteColor = UIColor.lightGray.cgColor
    let blackColor = UIColor.darkGray.cgColor
    let activeColor = UIColor.yellow.cgColor
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func drawPieces() {
        layer.sublayers?[0].setNeedsDisplay()
        layer.setNeedsLayout()
        for (i, row) in viewmodel.board.enumerated() {
            for (j, piece) in row.enumerated() {
                if  piece != nil {
                    
                    let pieceLayer = createPieceLayer(piece: piece?.chessPiece, color: piece?.chessColor)
                    //let pieceLayer = createPieceLayerPaint(color: piece?.chessColor)
                    
                    drawPiece(xPos: CGFloat(j), yPos: CGFloat(i), piece: pieceLayer)
                    
                    layer.addSublayer(pieceLayer)
                    
                }
            }
        }
    }
    
    
    /* func createPieceLayerPaint(color: Model.ChessColor?) -> CALayer {
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
     }*/
    
    
    
    
 
    func drawPiece(xPos: Double,yPos: Double ,piece: CALayer) {
        
        piece.setAffineTransform(
            CGAffineTransform(translationX: squareSize * xPos + offset, y: squareSize * yPos )
        )
    }
    
    func createPieceLayer(piece: Model.ChessPiece?, color: Model.ChessColor?) -> CALayer {
        
        let pieceLayer = CALayer()
        pieceLayer.bounds = CGRect(x:0,y:0,width:squareSize,height: squareSize)
        pieceLayer.position = CGPoint(x: squareSize / 2, y: squareSize / 2)
        
        let imageName: String
        switch (piece, color) {
        case (.king, .white):
            imageName = "white_king"
        case (.rook, .white):
            imageName = "white_rook"
        case (.pawn, .white):
            imageName = "white_pawn"
        case (.bishop, .white):
            imageName = "white_bishop"
        case (.knight, .white):
            imageName = "white_knight"
        case (.queen, .white):
            imageName = "white_queen"
        case (.king, .black):
            imageName = "black_king"
        case (.rook, .black):
            imageName = "black_rook"
        case (.pawn, .black):
            imageName = "black_pawn"
        case (.knight, .black):
            imageName = "black_knight"
        case (.bishop, .black):
            imageName = "black_bishop"
        case (.queen, .black):
            imageName = "black_queen"
        default:
            imageName = ""
        }
        
        if let image = UIImage(named: imageName) {
            pieceLayer.contents = image.cgImage
        }
        
        pieceLayer.contentsGravity = .resizeAspect
        
        return pieceLayer
    }
    
    
    
    func drawBoard() {
        
        let  squareSize =  bounds.width / 8
        let rowWidth = bounds.width
        
        for row in  0..<8 {
            let rowView = UIView()
            rowView.layer.frame = CGRect(x: 0 , y:   CGFloat(row) * squareSize, width: rowWidth, height: squareSize)
            self.addSubview(rowView)
          

            for col in 0..<8 {
                let colView = UIView()
                let x = CGFloat(col) * squareSize
        
                colView.layer.frame = CGRect(x: x , y: 0, width: squareSize, height: squareSize)
                let color  = (row + col) % 2 == 0 ? whiteColor  : blackColor
                colView.layer.backgroundColor = color
                rowView.addSubview(colView)
                let tapGeseture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                colView.addGestureRecognizer(tapGeseture)
            
                
            }
        }
       
     
        
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("called")
        if let colView = sender.view,
           let rowView = colView.superview
          {
            let rowIndex = subviews.firstIndex(of: rowView)

            let colIndex = rowView.subviews.firstIndex(of: colView)
            viewmodel.handleMove(data: ViewModel.Coordinates(row: rowIndex!, column: colIndex!))
            print(viewmodel.fromPosition)
            print(viewmodel.toPosition)
            if viewmodel.fromPosition != nil {
                
                if viewmodel.toPosition != nil {
                   let row = viewmodel.fromPosition!.row
                    let col = viewmodel.fromPosition!.column
                    subviews[row].subviews[col].backgroundColor = viewmodel.previousColor
                    
           
                    self.setNeedsDisplay(self.layer.frame)
                    viewmodel.clearValues()
                   
                } else {
                    viewmodel.previousColor =  colView.backgroundColor
                    colView.backgroundColor = UIColor(cgColor:activeColor)
                }
            }
            
            
            
            
        } else {
            print(sender.view?.bounds.maxY ?? "sender view does not exist")
            print(sender.view?.superview ??  "super view does not exist")
            print("not found")
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
