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
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let fingerLocation  = touches.first?.location(in: self)
        print(fingerLocation ?? 0)
        if fingerLocation != nil && fingerLocation?.x != nil && fingerLocation?.y != nil {
            let column = Int((fingerLocation?.x ?? -1)  / (squareSize))
            let row = Int((fingerLocation?.y ?? -1) / squareSize)
            
                viewmodel.handleMove(data: viewmodel.setCoordinates(row: row, column: column))
            
            var squarePreviousColor: CGColor? = nil
            
            
            if viewmodel.fromPosition != nil {
                
                if viewmodel.toPosition != nil {
                    drawPieces()
                    let tappedSquareIndex =  viewmodel.fromPosition!.row * 8 + viewmodel.fromPosition!.column
                    let tappedSquare = layer.sublayers?[tappedSquareIndex]
                    tappedSquare?.backgroundColor = viewmodel.previousColor!
                    
                    viewmodel.previousColor = nil
                    viewmodel.fromPosition = nil
                    viewmodel.toPosition = nil
                } else {
                    let tappedSquareIndex =  viewmodel.fromPosition!.row * 8 + viewmodel.fromPosition!.column
                    let tappedSquare = layer.sublayers?[tappedSquareIndex]
                    viewmodel.previousColor = tappedSquare?.backgroundColor
                    tappedSquare?.backgroundColor = activeColor
                    
                }
                
            }
            
            print ("from: \(viewmodel.fromPosition) to: \(viewmodel.toPosition)")
            
        }
    }
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
        for row in 0..<8 {
            for col in 0..<8 {
                let squareLayer = CALayer()
                squareLayer.frame = CGRect(x: CGFloat(col) * squareSize + offset , y: CGFloat(row) * squareSize, width: squareSize, height: squareSize)
                let color  = (row + col) % 2 == 0 ? whiteColor  : blackColor
                squareLayer.backgroundColor = color
                layer.addSublayer(squareLayer)
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
