//
//  MoveSet.swift
//  chess
//
//  Created by Elias Just on 03.05.23.
//

import Foundation

class MoveSet {
    
    typealias Piece = Model.Piece
    typealias ChessColor = Model.ChessColor
    typealias Coordinates = ViewModel.Coordinates


    var fromSquare: Coordinates? = nil
    var toSquare: Coordinates? = nil
    
    var currentTurnColor: ChessColor = .white
    ///needed for en passant
    var pawnMadeTwoMoves: Coordinates? = nil
   /*
    let model = ViewModel.board
    
    
    
    static func getValidMovesPawn(position:Coordinates) -> [Coordinates?] {
        var coordinates: [Coordinates?] = [Coordinates]()
        
        let pieceColor = getColorsFromCoords(coords: position)
        let (direction, baseRow) = pieceColor == .white ? (-1, 6) : (1, 1)
   
        if board[position.row + direction][position.column] == nil {
            coordinates.append(Coordinates(row: position.row + direction, column: position.column))
            if position.row == baseRow && board[position.row + direction * 2][position.column] == nil  {
                coordinates.append(Coordinates(row: position.row + direction * 2, column: position.column))
            }
        }
        
        /// all for en passant
        return coordinates + getThreatenedSquaresPawn(position: position).compactMap { coord -> Coordinates? in
            guard let coord = coord, board[coord.row][coord.column] != nil || (pawnMadeTwoMoves?.row == coord.row + direction && pawnMadeTwoMoves?.column == coord.column) else { return nil }
            return coord
        }
        
    }
    

    static func getThreatenedSquaresPawn(position:Coordinates) -> [Coordinates?] {
        let directions = (board[position.row][position.column]?.chessColor == .white) ? [(-1, -1), (-1, 1)] : [(1, -1), (1, 1)]
        return getValidMovesWithDirections(position, directions: directions, maxReach: 1)
    }
    
    
    
    static func transformPawn(square:Coordinates?) -> Void {
        let piece =  Piece(chessPiece: .queen, chessColor: getColorsFromCoords(coords: square!))
        model.board[square!.row][square!.column] = piece
    }
    
 
    
    static func getValidMovesRook(_ square:Coordinates) -> [Coordinates?] {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 7)
    }
    static func getValidMovesBishop(_ square:Coordinates) -> [Coordinates?] {
        let directions = [(1, 1), (1, -1), (-1, 1), (-1, -1)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 7)
    }
    static func getValidMovesKnight(_ square:Coordinates) -> [Coordinates?] {
        let directions = [(-1, -2), (-2, -1), (-2, 1), (-1, 2),  (1, 2), (2, 1), (2, -1), (1, -2)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 1)
    }
    
    static func getValidMovesQueen(_ square: Coordinates) -> [Coordinates?] {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0),(1, 1), (1, -1), (-1, 1), (-1, -1)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 7)
    }
    static func getValidMovesKing(_ square:Coordinates) -> [Coordinates?] {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0),(1, 1), (1, -1), (-1, 1), (-1, -1)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 1)
    }
    
    
    static func getValidMovesWithDirections(_ square: Coordinates, directions: [(Int,Int)], maxReach: Int) -> [Coordinates?] {
        var validMoves: [Coordinates?] = []
        let movingPiece = board[square.row][square.column]
        
        for direction in directions {
            var count = 0
            var newCoord = Coordinates(row: square.row + direction.0, column: square.column + direction.1)
            
            while isValidCoordinate(cord: newCoord, color: movingPiece!.chessColor) && count < maxReach {
                validMoves.append(newCoord)
                
                if board[newCoord.row][newCoord.column] != nil {break}
                
                newCoord.row += direction.0
                newCoord.column += direction.1
                count += 1
                
            }
        }
        
        return validMoves
        
    }
    /// validates that coordinates are on the board and the square there is not a piece with the same color
    static func isValidCoordinate(cord: Coordinates, color: ChessColor) -> Bool {
        return cord.row >= 0 && cord.row < 8 && cord.column >= 0 && cord.column < 8 && color != board[cord.row][cord.column]?.chessColor
    }
    
    static func getColorsFromCoords(coords:Coordinates) -> ChessColor {
        board[coords.row][coords.column]!.chessColor
    }
    */
    
}
