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
    
    let whiteColor = UIColor.gray.cgColor
    let blackColor = UIColor.black.cgColor
    

    
    fileprivate func drawPeaces(_ view: UIView) {
        //drawPeace(xPos: 4, yPos: 7, king: kingLayer)
        //view.transform =  CGAffineTransform(scaleX: 1.5, y: 1.5)
        //view.layer.setAffineTransform(CGAffineTransform(rotationAngle: 45))
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
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: boardSize, height: boardSize))
        //let layerSize = view.layer.bounds.width
        //let transform = CGAffineTransform(translationX: view.layer.bounds.width / 2, y:
        drawBoard(view)
        drawPeaces(view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        
    }
    
    func drawPeace(xPos: Double,yPos: Double ,peace: CALayer) {
        peace.setAffineTransform(
            CGAffineTransform(translationX: squareSize * xPos , y: squareSize * yPos )
        )
    }
    
    func createPeaceLayer(color: Model.ChessColor?) -> CALayer {
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
            
        peaceLayer.fillColor = UIColor.clear.cgColor
        
        return peaceLayer
    }

    
    

     func drawBoard(_ view: UIView) {
        //king.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //king.transform = CGAffineTransform(scaleX: 2, y: 2)
        //king.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
        let  squareSize =  view.layer.bounds.width / 8
        for row in 0..<8 {
            for col in 0..<8 {
                let squareLayer = CALayer()
                
                squareLayer.frame = CGRect(x: CGFloat(col) * squareSize, y: CGFloat(row) * squareSize, width: squareSize, height: squareSize)
                
                
                if (row + col) % 2 == 0 {
                    squareLayer.backgroundColor = whiteColor
                } else {
                    squareLayer.backgroundColor = blackColor
                    
                }
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
