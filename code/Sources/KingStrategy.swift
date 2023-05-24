//
//  KingStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation


class KingStrategy:Rule, ThreatRule {
    
    let viewmodel: ViewModel
    let maxReach = 1
    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0),(1, 1), (1, -1), (-1, 1), (-1, -1)]
    
    
    init() {
        viewmodel = ViewModel()
    }
    func validMoves(_ position: ViewModel.Coordinates, _ board: Model.BoardClass) -> [ViewModel.Coordinates] {
        return getThreatenPieces(position, board) + viewmodel.getValidRochadeSquares(position, board)

    }
    
    func getThreatenPieces(_ position: ViewModel.Coordinates, _ board: ViewModel.BoardClass) -> [ViewModel.Coordinates] {
       
        return viewmodel.getValidMovesWithDirections(position, directions: directions, maxReach: maxReach, board)
    }
    
    
}
