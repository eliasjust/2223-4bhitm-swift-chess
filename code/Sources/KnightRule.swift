//
//  KnightStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation

class KnightRule:Rule {
    
    
    
    init(model: Model, color: Model.ChessColor) {
        
        super.init(model: model, maxReach: 1, directions: moveDirectionsForPiece[.knight]!, color: color)
        
    }
    
    
    
}
