//
//  ViewModel.swift
//  chess
//
//  Created by Elias Just on 21.03.23.
//

import Foundation
import SwiftUI


let squareSize = 40.0
class ViewModel: ObservableObject {
    func drawKing(xPos: Double,yPos: Double ,king: CALayer) -> CALayer {
        
        king.setAffineTransform(
            CGAffineTransform(translationX: xPos , y: yPos )
        )
        return king
    }
}
