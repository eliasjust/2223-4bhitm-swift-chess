//
//  MoveStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation

class  Rule {
    typealias Coordinates = ViewModel.Coordinates
    var maxReach: Int
    var directions: [Direction]
    var model: Model
    var board: Model.BoardClass {model.board}
    var color:Model.ChessColor
    
    init(model: Model, maxReach:Int, directions:[Direction], color: Model.ChessColor) {
        self.model = model
        self.directions = directions
        self.maxReach = maxReach
        self.color = color
    }
    
    
    //change to mapper
    func getValidMovesWithDirections(_ square: Coordinates, _ optionalMoveDirections:[Direction] = []) -> [Coordinates] {
        
        let directions =  optionalMoveDirections.isEmpty ? self.directions : directions
        print(square)
        print(directions)
        var validMoves: [Coordinates] = []
        guard let movingPiece = board[square.row][square.column]  else {return validMoves}
        
        for direction in directions {
            var count = 0
            var newCoord = Coordinates(row: square.row + direction.x, column: square.column + direction.y)
            
            while isValidCoordinate(cord: newCoord, color: movingPiece.chessColor) && count < maxReach {
                validMoves.append(newCoord)
                
                if board[newCoord.row][newCoord.column] != nil {break}
                
                newCoord.row += direction.x
                newCoord.column += direction.y
                count += 1
                
            }
        }
        return validMoves
    }
    
    
    /// validates that coordinates are on the board and the square there is not a piece with the same color
    func isValidCoordinate(cord: Coordinates, color: Model.ChessColor) -> Bool {
        return cord.row >= 0 && cord.row < 8 && cord.column >= 0 && cord.column < 8 && color != board[cord.row][cord.column]?.chessColor
    }
    
    
    
    
    
    
    func getChessPiece(_ square: Coordinates) -> Model.Piece {
        board[square.row][square.column]!
    }
    
    func pieceIsOnSquares(squares: [Coordinates], piece: Model.Piece) -> Bool {
        return squares.contains { board[$0.row][$0.column] == piece }
    }
    
    
   fileprivate func getColorsFromCoords(_ coords:Coordinates) -> Model.ChessColor {
        board[coords.row][coords.column]!.chessColor
    }
    
    
    
    func validMoves(_ position:Coordinates) -> [Coordinates] {
        
        return getValidMovesWithDirections(position)
        
    }
    
    
    func getThreatenPieces( _ position:Coordinates) -> [Coordinates] {
        return getValidMovesWithDirections(position)
    }
    
    
    static func getRuleByChessPiece(model:Model,color:Model.ChessColor,chessPiece:Model.ChessPiece) -> Rule {
        
        
        
        let allRules:[Model.ChessPiece: Rule] = [
            .king: KingRule(model: model, color: color),
            .pawn: PawnRule(model:model, color: color),
            .queen: QueenRule(model:model,color:color),
            .knight: KnightRule(model:model,color:color),
            .rook: RookRule(model:model, color:color),
            .bishop: BishopRule(model:model, color: color)
        ]
        return allRules[chessPiece]!
    }
    
    
    
}
