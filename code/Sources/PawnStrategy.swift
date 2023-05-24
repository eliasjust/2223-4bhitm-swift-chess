//
//  PawnStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation


class PawnStrategy: Rule, ThreatRule {
   
    
    let viewmodel : ViewModel
    

    
    typealias Coordinates = ViewModel.Coordinates
    typealias BoardClass = ViewModel.BoardClass
    
    
    init() {
        self.viewmodel = ViewModel()
    }
    
    func validMoves(_ position:Coordinates, _ board:BoardClass) -> [Coordinates] {
        var coordinates: [Coordinates] = [Coordinates]()
        
        
        let pieceColor = viewmodel.getColorsFromCoords(position, board)
        let (direction, baseRow) = pieceColor == .white ? (-1, 6) : (1, 1)
        
        if board[position.row + direction][position.column] == nil {
            coordinates.append(Coordinates(row: position.row + direction, column: position.column))
            if position.row == baseRow && board[position.row + direction * 2][position.column] == nil  {
                coordinates.append(Coordinates(row: position.row + direction * 2, column: position.column))
            }
        }
        
        /// all for en passant
        return coordinates + getThreatenPieces(position, board).compactMap { $0 }.filter { coord -> Bool in
            if board[coord.row][coord.column] != nil {
                return true
            } else if let pawnMadeTwoMoves = viewmodel.pawnMadeTwoMovesSquare,
                      coord.row == (pawnMadeTwoMoves.row + direction) && coord.column == pawnMadeTwoMoves.column {
                return true
            }
            return false
        }
    }
    
    
    func getThreatenPieces( _ position:Coordinates, _ board: BoardClass) -> [Coordinates] {
        let directions = (board[position.row][position.column]?.chessColor == .white) ? [(-1, -1), (-1, 1)] : [(1, -1), (1, 1)]
        return viewmodel.getValidMovesWithDirections(position, directions: directions, maxReach: 1, board)
    }
}
