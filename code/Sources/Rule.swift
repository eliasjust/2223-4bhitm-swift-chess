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
    var color: Model.ChessColor
    
    init(model: Model, maxReach:Int, directions:[Direction], color: Model.ChessColor) {
        self.model = model
        self.directions = directions
        self.maxReach = maxReach
        self.color = color
    }
    
    
    //change to mapper
    func getValidMovesWithDirections(_ square: Coordinates,_ board: Model.BoardClass) -> [Coordinates] {
        var validMoves: [Coordinates] = []
        guard let movingPiece = board[square.row][square.column]  else {return validMoves}
        
        for direction in directions {
            var count = 0
            var newCoord = Coordinates(row: square.row + direction.x, column: square.column + direction.y)
            
            while isValidCoordinate(cord: newCoord, color: movingPiece.chessColor, board) && count < maxReach {
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
    func isValidCoordinate(cord: Coordinates, color: Model.ChessColor, _ board: Model.BoardClass) -> Bool {
        return cord.row >= 0 && cord.row < 8 && cord.column >= 0 && cord.column < 8 && color != board[cord.row][cord.column]?.chessColor
    }
    
    
    
    
    
    
    func getChessPiece(_ square: Coordinates) -> Model.Piece {
        board[square.row][square.column]!
    }
    
    func pieceIsOnSquares(squares: [Coordinates], piece: Model.Piece, _ board: Model.BoardClass) -> Bool {
        return squares.contains { board[$0.row][$0.column] == piece }
    }
    
    
    fileprivate func getColorsFromCoords(_ coords:Coordinates) -> Model.ChessColor {
        board[coords.row][coords.column]!.chessColor
    }
    
    
    
    func validMoves(_ position:Coordinates, _ board: Model.BoardClass) -> [Coordinates] {
        
        return getValidMovesWithDirections(position, board)
        
    }
    
    
    func getThreatenPieces(_ position:Coordinates, _ board: Model.BoardClass) -> [Coordinates] {
        return getValidMovesWithDirections(position, board)
    }
    
    
    static func getRuleByChessPiece(model: Model, color: Model.ChessColor, chessPiece: Model.ChessPiece) -> Rule {
    
        let allRules:[Model.ChessPiece: Rule] = [
            .king: KingRule(model: model, color: color),
            .pawn: PawnRule(model: model, color: color),
            .queen: QueenRule(model: model, color: color),
            .knight: KnightRule(model: model, color: color),
            .rook: RookRule(model: model, color: color),
            .bishop: BishopRule(model: model, color: color)
        ]
        return allRules[chessPiece]!
    }
    
    
    /**
     Filters the given possible moves for a piece to only include moves that do not result in the king being in check.

     - Parameters:
        - from: The current coordinates of the piece.
        - moves: An array containing all the potential moves for the piece.
        - board: The current state of the chess board.
        
     - Returns: An array of `Coordinates` representing the valid moves where the king is not in check.

     This function works by creating a hypothetical board for each possible move, and then checking if the king would be in check on that hypothetical board. Only the moves that do not result in the king being in check are returned.

    */
    func getMovesThatAreNotInCheck(from: Coordinates, moves: [Coordinates], _ board:Model.BoardClass) -> [Coordinates] {
        return moves.filter {
            let hypotheticalBoard =  hypotheticalMove(from: from, to: $0)
            if $0.column == 5 && $0.row == 1 {
                var a = !isKingInCheck(square: findKing(model.currentTurnColor, hypotheticalBoard), hypotheticalBoard)
                print(!isKingInCheck(square: findKing(model.currentTurnColor, hypotheticalBoard), hypotheticalBoard))
            }
            return !isKingInCheck(square: findKing(model.currentTurnColor, hypotheticalBoard), hypotheticalBoard)
        }
    }
    
    
    func getOpponentColor(color: Model.ChessColor)  -> Model.ChessColor{
        return color == .black ? .white : .black
    }
    func hypotheticalMove(from: Coordinates, to:Coordinates) -> Model.BoardClass {
        var board = model.board
        board[to.row][to.column] = board[from.row][from.column]
        board[from.row][from.column] = nil
        return board
    }
    
    
    func getAllValidMovesForSquare(square: Coordinates) -> [Coordinates] {
        typealias MoveFunction = (Coordinates, _ board: Model.BoardClass) -> [Coordinates]
        let board = board
        let piece = getChessPiece(square)
        let ruleForThePiece = Rule.getRuleByChessPiece(model: model, color: piece.chessColor, chessPiece: piece.chessPiece)
        
        let validMovesForPiece: [Coordinates] = ruleForThePiece.validMoves(square, board)
        return getMovesThatAreNotInCheck(from: square, moves: validMovesForPiece, board)
    }
    
    
    func getAllValidMoves(model: Model, forColor: Model.ChessColor) -> [Coordinates] {
        var validSquares: [Coordinates] = []
        getPiecesForColor(color: forColor, board: model.board).forEach{
            validSquares += getAllValidMovesForSquare(square: $0.1)
        }
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
        let turnColor = model.currentTurnColor
        let kingPosition = findKing(turnColor, model.board)
        let areNoThereValidMoves = getAllValidMoves(model: model, forColor: turnColor).isEmpty
        if areNoThereValidMoves {
            let rule = Rule(model: model, maxReach: 7, directions: [], color: turnColor)
            if rule.isKingInCheck(square:  kingPosition, model.board) {
                print("\(model.currentTurnColor) is Checkmate")
                model.isCheckMate = turnColor
            }else {
                model.isDraw = true
                print("it ist Draw")
            }
        }
    }
    
    
    
    func getColorsFromCoords(_ coords:Coordinates,_ board: Model.BoardClass) -> Model.ChessColor {
        board[coords.row][coords.column]!.chessColor
    }
    
    
    
    
    func isKingInCheck(square: Coordinates, _ board: Model.BoardClass) -> Bool {
        let kingColor = getColorsFromCoords(square, board)
        let opponentColor: Model.ChessColor = kingColor == .white ? .black : .white
        for (piece,cooridnates) in getPiecesForColor(color: opponentColor, board: board) {
            
            
            let rule = Rule.getRuleByChessPiece(model: model, color: opponentColor, chessPiece: piece.chessPiece)
        
            if cooridnates.row == 4 && cooridnates.column == 2 {
                print("")
            }
            if rule.getThreatenPieces(cooridnates, board).contains(square) {
                return true
            }
        }
        
        
        return false
    }
    
    
    
    func getPiecesForColor(color: Model.ChessColor, board: Model.BoardClass) -> [(Model.Piece, Coordinates)] {
        var pieces:[(Model.Piece, Coordinates)] = []
        
        for (rowIndex, row) in board.enumerated() {
            for(colIndex, column) in row.enumerated() {
                if (column != nil && column!.chessColor == color) {
                    pieces.append((column!, Coordinates(row: rowIndex, column: colIndex)))
                }
            }
        }
        return pieces
    }
    
}


