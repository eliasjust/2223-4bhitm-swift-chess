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
    override func validMoves(_ position: ViewModel.Coordinates) -> [ViewModel.Coordinates] {
        return getThreatenPieces(position) + getValidRochadeSquares(position)

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
    
    
    
    
    func isKingInCheck(square: Coordinates, _ board: Model.BoardClass) -> Bool {
        let kingColor = color
        let opponentColor: Model.ChessColor = kingColor == .white ? .black : .white

        typealias MoveFunction = (Coordinates) -> [Coordinates]
      
        let ruleForEachChessType: [Model.ChessPiece:MoveFunction] = [
        
            
            .king: self.getThreatenPieces,
            .bishop: BishopRule(model: self.model, color: opponentColor).getThreatenPieces,
            .knight: KnightRule(model: self.model, color: opponentColor).getThreatenPieces,
            .queen: QueenRule(model: self.model, color: opponentColor).getThreatenPieces,
            .rook: RookRule(model: self.model, color: opponentColor).getThreatenPieces,
            .pawn: PawnRule(model:self.model, color: opponentColor).getThreatenPieces(_:)
        
        ]
        for pieceType in Model.ChessPiece.allCases {
            
            
            let piece = Model.Piece(chessPiece: pieceType, chessColor: opponentColor)
            let squares =  ruleForEachChessType[pieceType]!(square)
            if  pieceIsOnSquares(squares: squares, piece: piece) {
            return true
            }
        }
       
        return false
    }
    
    func hypotheticalMove(from: Coordinates, to:Coordinates) -> Model.BoardClass {
        var board = model.board
        board[to.row][to.column] = board[from.row][from.column]
        board[from.row][from.column] = nil
        return board
    }
    

    
    
}
