//
//  KnightStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation

class KnightStrategy:Rule {
    let maxReach = 1
    let directions = [(-1, -2), (-2, -1), (-2, 1), (-1, 2),  (1, 2), (2, 1), (2, -1), (1, -2)]
    let viewModel: ViewModel
    
    init() {
        viewModel = ViewModel()
    }
    func validMoves(_ position: ViewModel.Coordinates, _ board: Model.BoardClass) -> [ViewModel.Coordinates] {
        
        return viewModel.getValidMovesWithDirections(position, directions: directions, maxReach: maxReach, board)
        
    }
    
    
}
