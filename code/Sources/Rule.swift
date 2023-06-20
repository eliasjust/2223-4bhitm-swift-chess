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
    func getValidMovesWithDirections(_ square: Coordinates,_ board:Model.BoardClass) -> [Coordinates] {
        
        
        
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
    
    
    
    func validMoves(_ position:Coordinates, _ board: Model.BoardClass) -> [Coordinates] {
        
        return getValidMovesWithDirections(position, board)
        
    }
    
    
    func getThreatenPieces( _ position:Coordinates, _ board: Model.BoardClass) -> [Coordinates] {
        return getValidMovesWithDirections(position, board)
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
    
    
    
    func getMovesThatAreInCheck(from: Coordinates, moves: [Coordinates], _ board:Model.BoardClass) -> [Coordinates] {
        let kingRule = KingRule(model: model, color: model.currentTurnColor)
        return moves.filter {
            let hypotheticalBoard =  hypotheticalMove(from: from, to: $0)
            return kingRule.isKingInCheck(square: findKing(model.currentTurnColor, hypotheticalBoard), hypotheticalBoard)
        }
    }
    
    
    
    func hypotheticalMove(from: Coordinates, to:Coordinates) -> Model.BoardClass {
        var board = model.board
        board[to.row][to.column] = board[from.row][from.column]
        board[from.row][from.column] = nil
        return board
    }
    
    
    func getValidMoves(position:Coordinates) -> [Coordinates] {
        
        
        
        
     
        typealias MoveFunction = (Coordinates,_  board: Model.BoardClass) -> [Coordinates]
        
        let kingRule = KingRule(model: model, color: model.currentTurnColor)
        let piece = getChessPiece(position)
        let ruleForThePiece = Rule.getRuleByChessPiece(model: model, color: piece.chessColor, chessPiece: piece.chessPiece)
        
        let validMoves: [Coordinates] = ruleForThePiece.validMoves(position, board)
        let movesThatAreInCheck = kingRule.getMovesThatAreInCheck(from: position, moves: validMoves, board)
        
        return validMoves.filter { !movesThatAreInCheck.contains($0) }
    }
    
    
    func getAllValidMoves(model: Model) -> [Coordinates] {
        var validSquares: [Coordinates] = []
        
        
        for (row,rowPieces) in model.board.enumerated() {
            for (col,pieces) in rowPieces.enumerated() {
                if pieces?.chessColor == model.currentTurnColor {
                    validSquares += getValidMoves(position: Coordinates(row: row, column: col))
                }
            }
        }
        print(validSquares)
        
        return validSquares
        
    }
    
    func findKing(_ color: Model.ChessColor, _ board: Model.BoardClass) -> Coordinates {
        findPiece(pieceToFind: Model.Piece(chessPiece: .king, chessColor: color), board)!
    }
    
    func findPiece(pieceToFind: Model.Piece, _ board: Model.BoardClass) -> Coordinates? {
        for (row, rowPieces) in board.enumerated() {
            if let column = rowPieces.firstIndex(where: { $0 == pieceToFind }) {
                return Coordinates(row: row, column: column)
            }
        }
        return nil
    }
    
    
     func handleGameStatus() -> Void  {
         let kingPosition = findKing(model.currentTurnColor, model.board)
        let kingRule = KingRule(model: model, color: model.currentTurnColor)
        print("Current position for the \(model.currentTurnColor) king \(kingPosition)" )
        let isThereValidMoves = getAllValidMoves(model: model).isEmpty
        print(isThereValidMoves)
        if isThereValidMoves {
            if  kingRule.isKingInCheck(square:  kingPosition, model.board) {
                print("\(model.currentTurnColor) is Checkmate")
                model.isCheckMate = model.currentTurnColor
            }else {
                model.isDraw = true
                print("it ist Draw")
            }
        }
    }
    
    
    
    func getColorsFromCoords(_ coords:Coordinates,_ board: Model.BoardClass) -> Model.ChessColor {
        board[coords.row][coords.column]!.chessColor
    }
    
    
    
}
