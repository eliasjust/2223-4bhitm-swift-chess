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
            BoardViewWrapper(viewmodel: viewmodel).padding()
            
        }.padding()
        
    }
}
struct BoardViewWrapper: UIViewRepresentable {
    var viewmodel: ViewModel
    func makeUIView(context: Context) -> some UIView {
        let myUiView = BoardView(viewModel: viewmodel)
        return myUiView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}




    
    
    struct BordComposition: UIViewRepresentable {
        var viewmodel: ViewModel
        var parentSize: CGSize
        var boardSize: CGFloat { min(parentSize.width, parentSize.height) * 0.9 }
        var squareSize: CGFloat { boardSize / 8 }
        var offset: CGFloat { (parentSize.width - boardSize) / 2 }
        let whiteColor = UIColor.gray.cgColor
        let blackColor = UIColor.black.cgColor
        let activeColor = UIColor.yellow.cgColor
        
        
        
        fileprivate func drawPieces(_ view: UIView) {
            for (i, row) in viewmodel.board.enumerated() {
                for (j, piece) in row.enumerated() {
                    if  piece != nil {
                        
                        //let pieceLayer = createPieceLayer(piece: piece?.chessPiece, color: piece?.chessColor)
                        let pieceLayer = createPieceLayerPaint(color: piece?.chessColor)
                        
                        drawPiece(xPos: CGFloat(j), yPos: CGFloat(i), piece: pieceLayer)
                        
                        view.layer.addSublayer(pieceLayer)
                        
                    }
                }
            }
        }
        
        
        func makeUIView(context: Context) -> UIView {
            let view = UIView(frame: CGRect(x: offset, y: 0, width: boardSize, height: boardSize))
            
            
            
            
            
            
            //let layerSize = view.layer.bounds.width
            //let transform = CGAffineTransform(translationX: view.layer.bounds.width / 2, y:
            
            view.layer.setAffineTransform(CGAffineTransform(translationX: boardSize/2, y: boardSize/2))
            
            
            drawBoard(view)
            drawPieces(view)
            return view
        }
        
        
        
        func updateUIView(_ uiView: UIView, context: Context) {
            
            
        }
        
        
       
        
        
        
        func drawPiece(xPos: Double,yPos: Double ,piece: CALayer) {
            
            piece.setAffineTransform(
                CGAffineTransform(translationX: squareSize * xPos + offset, y: squareSize * yPos )
            )
        }
        
        func createPieceLayer(piece: Model.ChessPiece?, color: Model.ChessColor?) -> CALayer {
            let pieceLayer = CALayer()
            
            pieceLayer.bounds = CGRect(x: 0, y: 0, width: squareSize, height: squareSize)
            
            //        pieceLayer.position = CGPoint(x: squareSize / 2, y: squareSize / 2)d
            
            let imageName: String
            switch (piece, color) {
            case (.king, .white):
                imageName = "white_king"
            case (.king, .black):
                imageName = "yeah"
            default:
                imageName = ""
            }
            
            if let image = UIImage(named: imageName) {
                pieceLayer.contents = image.cgImage
            }
            
            pieceLayer.contentsGravity = .resizeAspect
            
            return pieceLayer
        }
        
        func createPieceLayerPaint(color: Model.ChessColor?) -> CALayer {
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
  
            pieceLayer.fillColor = UIColor.clear.cgColor
            return pieceLayer
        }
       
        
        func drawBoard(_ view: UIView) {
            //king.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            //king.transform = CGAffineTransform(scaleX: 2, y: 2)
            //king.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
            let  squareSize =  view.layer.bounds.width / 8
            for row in 0..<8 {
                for col in 0..<8 {
                    
                    let squareLayer = CALayer()
                    let frame = CGRect(x: CGFloat(col) * squareSize + offset , y: CGFloat(row) * squareSize, width: squareSize, height: squareSize)
                    squareLayer.frame = frame
                    let color =  (row + col) % 2 == 0 ? whiteColor : blackColor
                    
                    squareLayer.backgroundColor = color
                    squareLayer.backgroundColor = viewmodel.fromPosition != nil ? activeColor : squareLayer.backgroundColor
                    
                    view.layer.addSublayer(squareLayer)
                }
            }
            
            
        }
            
        
        
        
        
    }
    
    
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static let viewModel = ViewModel()
        static var previews: some View {
            ContentView(viewmodel: viewModel)
        }
    }
