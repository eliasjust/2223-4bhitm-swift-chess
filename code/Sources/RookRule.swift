//
//  RookStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation

class RookRule: Rule {
    func validMoves(_ position: ViewModel.Coordinates, _ board: Model.BoardClass) -> [ViewModel.Coordinates] {
        return viewModel.getValidMovesWithDirections(position, directions: directions, maxReach: maxReach, board)
    }
    
    let directions = [(0,1), (1, 0), (0, -1), (-1, 0)];
    let maxReach = 7
    let viewModel:ViewModel
    
    init() {
        self.viewModel = ViewModel()
    
    }
    
}
