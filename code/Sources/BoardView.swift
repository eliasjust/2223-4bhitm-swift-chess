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
                    subviews[i].subviews[j].subviews.forEach{$0.removeFromSuperview()}
                    let pieceView = createPieceLayer(piece: piece?.chessPiece, color: piece?.chessColor)
                    subviews[i].subviews[j].addSubview(pieceView)
                    
                }
            }
        }
    }
    
    
    
    

    
    func createPieceLayer(piece: Model.ChessPiece?, color: Model.ChessColor?) -> UIView {
        let pieceView = UIView()
        
        pieceView.layer.frame = CGRect(x:0,y:0,width:squareSize,height: squareSize)
       
        
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
            pieceView.layer.contents = image.cgImage
        }
        
        pieceView.layer.contentsGravity = .resizeAspect
        
        return pieceView
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
        if let colView = sender.view,
           let rowView = colView.superview
        {
            let rowIndex = subviews.firstIndex(of: rowView)
            let colIndex = rowView.subviews.firstIndex(of: colView)
            
            viewmodel.handleMove(data: ViewModel.Coordinates(row: rowIndex!, column: colIndex!))
            let fromPosition = viewmodel.fromPosition
            let toPosition = viewmodel.toPosition
            if fromPosition != nil {
                
                if toPosition != nil {

                    self.setNeedsDisplay()
                    self.viewmodel.clearValues()
                    
                } else {
                    colView.backgroundColor = UIColor(cgColor:activeColor)
                }
            }
            
            
            
            
        } else {
            print(sender.view?.bounds.maxY ?? "sender view does not exist")
            print(sender.view?.superview ??  "super view does not exist")
            print("not found")
        }
        
    }
    
    
    override func draw(_ rect:CGRect) {
        
        subviews.forEach{$0.removeFromSuperview()}
        drawBoard()
        drawPieces()
        
        
    }
    
    init(viewModel:ViewModel) {
        self.viewmodel = viewModel
        super.init(frame: CGRect.zero
        )
        super.frame =  CGRect(x: 0, y: 0, width: boardSize, height: boardSize)
        
        
        
        
        
        
    }
    
    
    
    
    
}
