//
//  PawnStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation


class PawnRule: Rule {
   
    
    let viewmodel : ViewModel
   
    

    
    typealias Coordinates = ViewModel.Coordinates
    typealias BoardClass = ViewModel.BoardClass
    
    
    init(model:Model, color: Model.ChessColor) {
       
        self.viewmodel = ViewModel()
        super.init(model: model, maxReach: 1, directions:
                    [Direction(x:0, y: color == .black ?  -1 : 1)], color: color
        
        )
    }
    
    override func validMoves(_ position:Coordinates) -> [Coordinates] {
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
        return coordinates + getThreatenPieces(position).compactMap { $0 }.filter { coord -> Bool in
            if board[coord.row][coord.column] != nil {
                return true
            } else if let pawnMadeTwoMoves = viewmodel.pawnMadeTwoMovesSquare,
                      coord.row == (pawnMadeTwoMoves.row + direction) && coord.column == pawnMadeTwoMoves.column {
                return true
            }
            return false
        }
    }
    
    
    override func getThreatenPieces( _ position:Coordinates) -> [Coordinates] {
        let moveDirections = self.directions
        let beatDirections = color == .black
        ? [Direction(x:-1, y:1), Direction(x:1, y:1)]
        : [Direction(x: 1, y: 1), Direction(x: -1, y: 1)]
        self.directions = beatDirections
        let result = super.getValidMovesWithDirections(position)
        self.directions = moveDirections
        return result
    }
}
