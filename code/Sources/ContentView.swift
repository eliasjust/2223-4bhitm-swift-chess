//
//  ContentView.swift
//  testapp
//
//  Created by Elias Just on 13.03.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewmodel : ViewModel
    var body: some View {
        VStack {
            BordComposition(viewmodel: viewmodel)
        }
        
    }
}



struct BordComposition: UIViewRepresentable {
    var viewmodel: ViewModel
    
    let boardSize: CGFloat = UIScreen.main.bounds.width
    var squareSize: CGFloat { boardSize / 8 }
    
    let whiteChessColor = UIColor.gray.cgColor
    let blackChessColor = UIColor.black.cgColor
    
     func makeUIView(context: Context) -> UIView {
        let boardView = UIView(frame: CGRect(x: 0, y: 0, width: boardSize, height: boardSize))
        drawBoard(boardView)
        drawPeaces(boardView)
        return boardView
    }
    
    
    func updateUIView(_ board: UIView, context: Context) {
        
    }
    
    
    private func drawBoard(_ view: UIView) {
        let  squareSize =  view.layer.bounds.width / 8
        for row in 0..<8 {
            for col in 0..<8 {
                let squareLayer = CALayer()
                
                squareLayer.frame = CGRect(x: CGFloat(col) * squareSize, y: CGFloat(row) * squareSize, width: squareSize, height: squareSize)
                
                
                if (row + col) % 2 == 0 {
                    squareLayer.backgroundColor = whiteChessColor
                } else {
                    squareLayer.backgroundColor = blackChessColor
                    
                }
                view.layer.addSublayer(squareLayer)
            }
        }
    }
    
    
    private func createPeaceLayer(color: Model.ChessColor?) -> CALayer {
        let peaceLayer = CAShapeLayer()
        let kingPath = UIBezierPath()
        
        
        kingPath.move(to: CGPoint(x: squareSize / 2, y: squareSize / 4))
        kingPath.addLine(to: CGPoint(x: squareSize / 2, y: 3 * squareSize / 4))
        kingPath.move(to: CGPoint(x: squareSize / 4, y: squareSize / 2))
        kingPath.addLine(to: CGPoint(x: 3 * squareSize / 4, y: squareSize / 2))
        
        peaceLayer.path = kingPath.cgPath
        peaceLayer.lineWidth = 3
        
        if color == .white {
            peaceLayer.strokeColor =
            UIColor.white.cgColor
            
        } else {
            peaceLayer.strokeColor =
            UIColor.black.cgColor
        }
        
        return peaceLayer
    }
    
    
    
    private func drawPeaces(_ view: UIView) {
        for (i, row) in viewmodel.board.enumerated() {
            for(j, piece) in row.enumerated() {
                let peaceLayer = createPeaceLayer(color: piece.color)
                
                if piece.piece != nil {
                    drawPeace(xPos: Double(i), yPos: Double(j), peace: peaceLayer)
                }
                view.layer.addSublayer(peaceLayer)
            }
        }
    }
    
    
    private func drawPeace(xPos: Double,yPos: Double ,peace: CALayer) {
        peace.setAffineTransform(
            CGAffineTransform(translationX: squareSize * xPos , y: squareSize * yPos )
        )
    }
}





struct ContentView_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    static var previews: some View {
        ContentView(viewmodel: viewModel)
    }
}
