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
                    let pieceView = createPieceLayer(piece: piece!.chessPiece, color: piece!.chessColor)
                    subviews[i].subviews[j].addSubview(pieceView)
                    
                }
            }
        }
    }
    
    func createPredictionCircle() -> UIView {
        
        
        let center = CGPoint(x: squareSize / 2 , y: squareSize / 2)
        let radius: CGFloat = squareSize / 4

       
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 2
     
        
        let circleView = UIView(frame: CGRect(x: 0, y:0 , width: radius * 2 , height: radius * 2))
        circleView.center = center
        circleView.backgroundColor =
        UIColor(cgColor:activeColor).withAlphaComponent(0.3)
        circleView.layer.cornerRadius = radius
        return circleView
        
        
    }
    
    fileprivate func drawPredictions() {
        viewmodel.predictions.forEach{subviews[$0!.row].subviews[$0!.column].addSubview(createPredictionCircle())}
    }
    
    
    
    

    
    func createPieceLayer(piece: Model.ChessPiece, color: Model.ChessColor) -> UIView {
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
            
            
            let rowIndex = subviews.firstIndex(of: rowView)!
            let colIndex = rowView.subviews.firstIndex(of: colView)!
            
            viewmodel.handleTap(tappedPosition: ViewModel.Coordinates(row: rowIndex, column: colIndex))
            
            let fromPosition = viewmodel.fromSquare
            let toPosition = viewmodel.toSquare
            if fromPosition != nil {
                drawPredictions()
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
