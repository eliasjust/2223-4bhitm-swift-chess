//
//  BishopStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation


class BishopRule: Rule {
    
 
    
    

    
    init(model:Model, color: Model.ChessColor) {
        super.init(model: model, maxReach: 7, directions: moveDirectionsForPiece[.bishop]!, color: color)
    }
    
    
 
    
}
