//
//  RookStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation


class RookRule: Rule {
    
    
    init(model:Model,color:Model.ChessColor) {
        
        super.init(model:model,maxReach: 7, directions:moveDirectionsForPiece[.rook]!, color: color)
        
    }
    
    
    
    
    
}
