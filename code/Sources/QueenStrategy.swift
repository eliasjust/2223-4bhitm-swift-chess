//
//  QueenStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation

class QueenStrategy: MoveStrategy {
    func getValidMoves(_ position: ViewModel.Coordinates, _ board: Model.BoardClass) -> [ViewModel.Coordinates] {
        return viewmodel.getValidMovesWithDirections(position, directions: directions, maxReach: maxReach, board)
    }
    
    
    let maxReach = 7
    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0),(1, 1), (1, -1), (-1, 1), (-1, -1)]
    var viewmodel:ViewModel
    
    init() {
        self.viewmodel = ViewModel()
    }
    
}
