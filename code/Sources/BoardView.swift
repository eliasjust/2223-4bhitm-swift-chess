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
    
    var fromSquare: ViewModel.Coordinates? = nil
    var squarePreviousColor: UIColor?
    var viewmodel: ViewModel
    
    let boardSize: CGFloat = UIScreen.main.bounds.width * 0.9
    var squareSize: CGFloat { boardSize  / 8 }
    let whiteColor = UIColor(red:227/255, green:193/255, blue: 111/255, alpha: 1 ).cgColor
    let blackColor = UIColor(red: 184/255, green: 139/255,blue: 74/255, alpha: 1 ).cgColor
    let activeColor = UIColor.systemBlue.cgColor
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func drawPieces() {
        
        for (i, row) in viewmodel.board.enumerated() {
            for (j, piece) in row.enumerated() {
                guard let validPiece = piece else {continue}
                
                let pieceView = createPieceLayer(piece: validPiece.chessPiece, color: validPiece.chessColor)
                subviews[i].subviews[j].addSubview(pieceView)
                
            }
        }
    }
    
    
    func createPredictionCircle(_ coordinates:ViewModel.Coordinates) -> UIView {
        let  squareSize =  bounds.width / 8
        
        let enemyStandsOnField =  viewmodel.enemyStandsOnSquare(coordinates)
        
        
        let center = CGPoint(x: squareSize / 2 , y: squareSize / 2)
        let radius: CGFloat =  enemyStandsOnField ? squareSize / 2  : squareSize / 4
        let fieldColor = enemyStandsOnField ? UIColor.red.cgColor : activeColor
        
        
        let shapeLayer = CAShapeLayer()
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        shapeLayer.path = path.cgPath
        
        let circleView = UIView(frame: CGRect(x: 0, y:0 , width: radius * 2 , height: radius * 2))
        circleView.center = center
        circleView.backgroundColor =  UIColor(cgColor:fieldColor).withAlphaComponent(0.3)
        circleView.layer.cornerRadius = radius
        
        
        return circleView
        
        
    }
    
    fileprivate func drawPredictions(_ predictions: [ViewModel.Coordinates] ) {
        predictions
            .forEach{
                subviews[$0.row].subviews[$0.column]
                    .addSubview(createPredictionCircle($0))
                
            }
    }
    
    
    
    
    
    
    func createPieceLayer(piece: Model.ChessPiece, color: Model.ChessColor) -> UIView {
        
        let  squareSize =  bounds.width / 8
        let rowWidth = bounds.width
        
        let pieceView = UIView()
        
        pieceView.layer.frame = CGRect(x:0,y:0,width:squareSize,height: squareSize)
        
        
        let imageName:String = "\(color.rawValue)_\(piece.rawValue)"
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
            
            
            guard let rowIndex = subviews.firstIndex(of: rowView) else {
                print ("The touched Row is not accessable ")
                return}
            guard let colIndex = rowView.subviews.firstIndex(of: colView) else {
                print ("The touched Column is not accessable ")
                return}
            
            
            let tappedAreaCoordinates = viewmodel.setCoordinates(row: rowIndex, column: colIndex)
            
            let pieceAtTappedArea = viewmodel.checkIfPieceOnTheGivenCoordinatesIsValid(tappedAreaCoordinates)
            
            if !pieceAtTappedArea && fromSquare == nil { return}
            if fromSquare == nil {
                
                print("Assigning FromSquare")
                fromSquare = tappedAreaCoordinates
                drawPredictions(viewmodel.getValidMoves(position: fromSquare!))
                squarePreviousColor = colView.backgroundColor
                colView.backgroundColor = UIColor(cgColor: activeColor)
                
                
            }
            
            
            else if tappedAreaCoordinates == fromSquare {
                print("Deselecting a piece")
                fromSquare = nil
                setNeedsDisplay()
            }
            
            
            
            else if pieceAtTappedArea && fromSquare != nil  {
                
                print("Changing the FromSquare Position")
                fromSquare = tappedAreaCoordinates
                setNeedsDisplay()
                //subviews[fromSquare!.row].subviews[fromSquare!.column].backgroundColor = squarePreviousColor
                
                
                
            }
            
            
            else  {
                
                print("Moving piece to \(tappedAreaCoordinates)")
                viewmodel.handleMove(fromPosition: fromSquare!, toPosition: tappedAreaCoordinates)
                
                fromSquare = nil
                self.setNeedsDisplay()
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
        if fromSquare != nil {
            subviews[fromSquare!.row].subviews[fromSquare!.column].backgroundColor = UIColor(cgColor: activeColor)
            drawPredictions(viewmodel.getValidMoves(position: fromSquare!))
            
        }
        
        
        
        highlightCheck(color: .white)
        highlightCheck(color: .black)
        
        
        
    }
    
    
    func highlightCheck (color: ViewModel.ChessColor) -> Void{
        let position = viewmodel.findKing(color, viewmodel.board)
        if viewmodel.isKingInCheck(position: position) {
            subviews[position.row].subviews[position.column].backgroundColor = UIColor.red
        }
    }
    
    init(viewModel:ViewModel) {
        self.viewmodel = viewModel
        super.init(frame: CGRect.zero
        )
        super.frame =  CGRect(x: 0, y: 0, width: boardSize, height: boardSize)
        
        
        
        
        
        
    }
    
    
    
    
    
}
