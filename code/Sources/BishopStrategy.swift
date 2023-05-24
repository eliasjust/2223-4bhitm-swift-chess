//
//  BishopStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation


class BishopStrategy: Rule {
    
    let maxReach = 7
    let directions =  [(1, 1), (1, -1), (-1, 1), (-1, -1)]
    func validMoves(_ position: ViewModel.Coordinates, _ board: Model.BoardClass) -> [ViewModel.Coordinates] {
        return viewModel.getValidMovesWithDirections(position, directions: directions, maxReach: maxReach, board)
    }
    
    
    let viewModel: ViewModel
    
    init() {
        self.viewModel = ViewModel()
    }
    
}
