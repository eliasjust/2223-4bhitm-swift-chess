//
//  KingStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation


class KingRule:Rule {

    
    init(model: Model, color: Model.ChessColor) {
      
        super.init(
            model: model, maxReach: 1, directions: moveDirectionsForPiece[.king]!, color: color)
    }
    override func validMoves(_ position: ViewModel.Coordinates, _ board: Model.BoardClass) -> [ViewModel.Coordinates] {
        return super.validMoves(position, board) + getValidRochadeSquares(position)

    }
    
   
    
    
    
    
    func getValidRochadeSquares(_ square: Coordinates) -> [Coordinates] {
        var validRochadeMoves: [Coordinates] = []
        let piece = getChessPiece(square)
         
        
        if piece.chessPiece == .king {
            if piece.chessColor == .white && !model.whiteKingHasMoved {
                if !model.a1whiteRookHasMoved && isValidRochadePath(square, direction: Direction(x:0, y:-1), maxReach: 3 ) {
                    validRochadeMoves.append(Coordinates(row: square.row, column: square.column - 2))
                }
                if !model.h1whiteRookHasMoved && isValidRochadePath(square, direction:Direction(x:0,y:1), maxReach: 2) {
                    validRochadeMoves.append(Coordinates(row: square.row, column: square.column + 2))
                }
            } else if piece.chessColor == .black && !model.blackKingHasMoved {
                if !model.a8blackRookHasMoved && isValidRochadePath(square, direction: Direction(x:0,y:-1), maxReach: 3) {
                    validRochadeMoves.append(Coordinates(row: square.row, column: square.column - 2))
                }
                if !model.h8blackRookHasMoved && isValidRochadePath(square, direction: Direction(x: 0, y: 1), maxReach: 2) {
                    validRochadeMoves.append(Coordinates(row: square.row, column: square.column + 2))
                }
            }
            
     
        }
        
      
        return validRochadeMoves
    }
    
    
    func isValidRochadePath(_ square: Coordinates, direction: Direction, maxReach: Int) -> Bool {
        var count = 0
        var newCoord = Coordinates(row: square.row + direction.x, column: square.column + direction.y)
        
        var kingChecked = isKingInCheck(square: square, board)
        
        

        while count < maxReach {
           
            if board[newCoord.row][newCoord.column] != nil || kingChecked {
                return false
            }
            
            
            let hypotheticalBoard = hypotheticalMove(from: square, to: newCoord)
            kingChecked = isKingInCheck(square: newCoord, hypotheticalBoard)

            
            newCoord.row += direction.x
            newCoord.column += direction.y
            count += 1
        }
        
        return true
    }
    
}
