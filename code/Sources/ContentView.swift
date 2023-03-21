//
//  ContentView.swift
//  testapp
//
//  Created by Elias Just on 13.03.23.
//

import SwiftUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
  
            Board().padding()
        }
        .padding()
    }
}



struct Board: UIViewRepresentable {
    let boardSize: CGFloat = 320.0
    let squareSize: CGFloat = 40.0
    let whiteColor = UIColor.gray.cgColor
    let blackColor = UIColor.black.cgColor
    
    func createKingLayer() -> CALayer {
        let kingLayer = CAShapeLayer()
        let kingPath = UIBezierPath()
        
      
        // Draw the cross
        kingPath.move(to: CGPoint(x: squareSize / 2, y: squareSize / 4))
        kingPath.addLine(to: CGPoint(x: squareSize / 2, y: 3 * squareSize / 4))
        kingPath.move(to: CGPoint(x: squareSize / 4, y: squareSize / 2))
        kingPath.addLine(to: CGPoint(x: 3 * squareSize / 4, y: squareSize / 2))
        
        kingLayer.path = kingPath.cgPath
        kingLayer.lineWidth = 3
        kingLayer.strokeColor = UIColor.white.cgColor
        kingLayer.fillColor = UIColor.clear.cgColor
        
        return kingLayer
    }

    
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: boardSize, height: boardSize))
        
        
        
        //king.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //king.transform = CGAffineTransform(scaleX: 2, y: 2)
        //king.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
    
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
        
        let kingLayer = createKingLayer()

        kingLayer.setAffineTransform(
            CGAffineTransform(translationX: 4 * squareSize, y: 0 * squareSize)
        )

        view.layer.addSublayer(kingLayer)

        return view
        
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        
    }
}


 


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
