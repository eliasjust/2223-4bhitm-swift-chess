//
//  ViewModel.swift
//  chess
//
//  Created by Elias Just on 21.03.23.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published private(set) var model =  Model()
    
    typealias Piece = Model.Piece
    typealias ChessColor = Model.ChessColor
    typealias ChessPiece = Model.ChessPiece
    let defaultBlackKingPos = Coordinates(row: 0, column: 4)
    let defaultWhiteKingPos = Coordinates(row: 7, column: 4)
    
    
    typealias BoardClass = [[Piece?]]
    
    var board: BoardClass {
        model.board
    }
    
    var fromSquare: Coordinates? = nil
    var toSquare: Coordinates? = nil
    
    var currentTurnColor: ChessColor = .white
    ///needed for en passant
    var pawnMadeTwoMovesSquare: Coordinates? = nil
    var predictions: [Coordinates] = []
    
    struct Coordinates: Equatable {
        var  row: Int
        var column: Int
    }
    
    func clearValues () {
        fromSquare = nil
        toSquare = nil
    }
    
    func setCoordinates (row: Int, column: Int) -> Coordinates {
        return Coordinates(row: row, column: column)
    }
    
    
    func handleTap(tappedPosition:Coordinates) -> Void {
        predictions = []
        let pieceAtGivenCoordinates = board[tappedPosition.row][tappedPosition.column]
        
        /// true: select piece; else: try to move piece
        if fromSquare == nil && pieceAtGivenCoordinates != nil && pieceAtGivenCoordinates?.chessColor == currentTurnColor {
            fromSquare = tappedPosition
            predictions = getValidMoves(position: tappedPosition)
        } else if fromSquare != nil && toSquare == nil {
            toSquare = tappedPosition
            handleMove()
        }
        
    }
    func enemyStandsOnSquare(_ position:Coordinates) -> Bool {
        return board[position.row][position.column] != nil
    }
    
    
    func handleMove() -> Void {
        guard let fromPosition = fromSquare else {return}
        guard let toPosition =  toSquare else {return}
        
        if moveIsValid(fromPosition: fromPosition, toPosition: toPosition) {
            
            guard let selectedPiece = board[fromPosition.row][fromPosition.column] else {return}
            switch selectedPiece.chessPiece {
            case .rook, .king:
                rookOrKingMoved(from: fromPosition, to: toPosition, chessPiece: selectedPiece.chessPiece)
            case .pawn:
                pawnMoves(fromSquare: fromPosition, toSquare:  toPosition)
            default:
                pawnMadeTwoMovesSquare = nil
            }
            
            
            if let piece = board[toPosition.row][toPosition.column] {
                capturePiece(piece)
            }
            movePiece(from: fromPosition, to: toPosition)
        }
    }
    
    func rookOrKingMoved(from: Coordinates, to: Coordinates, chessPiece: ChessPiece) -> Void {
        switch (from) {
        case Coordinates(row: 0,column: 0):
            model.a8blackRookHasMoved = true
        case Coordinates(row: 0, column: 7):
            model.h8blackRookHasMoved = true
        case Coordinates(row: 7, column: 0):
            model.a1whiteRookHasMoved = true
        case Coordinates(row: 7, column: 7):
            model.h1whiteRookHasMoved = true
        case defaultBlackKingPos:
            model.blackKingHasMoved = true
        case defaultWhiteKingPos:
            model.whiteKingHasMoved = true
        default:
            break
        }
        
        // Check if the king has moved two squares horizontally
        if chessPiece == .king && abs(from.column - to.column) == 2 {
            let rookFrom: Coordinates
            let rookTo: Coordinates
            
            if to.column > from.column { // Kingside castling
                rookFrom = Coordinates(row: from.row, column: 7)
                rookTo = Coordinates(row: to.row, column: to.column - 1)
            } else { // Queenside castling
                rookFrom = Coordinates(row: from.row, column: 0)
                rookTo = Coordinates(row: to.row, column: to.column + 1)
            }
            
            movePiece(from: rookFrom, to: rookTo)
        }
    }
    
    func movePiece(from:Coordinates, to:Coordinates) -> Void {
        model.board[to.row][to.column] = board[from.row][from.column]
        model.board[from.row][from.column] = nil
        currentTurnColor = (currentTurnColor == .white) ? .black : .white
    }
    func hypotheticalMove(from: Coordinates, to:Coordinates) -> BoardClass {
        var board = model.board
        board[to.row][to.column] = board[from.row][from.column]
        board[from.row][from.column] = nil
        return board
    }
    
    func capturePiece(_ piece:Piece) -> Void {
        return
    }
    
    func pawnMoves(fromSquare:Coordinates, toSquare:Coordinates ) -> Void {
        if toSquare.row == 0 || toSquare.row == 7  {
            transformPawn(square: fromSquare, board)
        }
        
        if fromSquare.column != toSquare.column && board[toSquare.row][toSquare.column] == nil {
            captureEnPasant(square: pawnMadeTwoMovesSquare!)
        }
        pawnMadeTwoMovesSquare = nil
        
        /// pawn moved two squares
        if fromSquare.row == 1 && toSquare.row == 3 || fromSquare.row == 6 && toSquare.row == 4 {
            pawnMadeTwoMovesSquare = toSquare
        }
        
    }
    
    func captureEnPasant(square:Coordinates) -> Void {
        guard  let piece = board[square.row][square.column] else {return}
        model.board[square.row][square.column] = nil
        capturePiece(piece)
    }
    
    
    func moveIsValid(fromPosition:Coordinates, toPosition:Coordinates) -> Bool {
        return getValidMoves(position: fromPosition).contains(where: {$0.column == toPosition.column && $0.row == toPosition.row})
        
    }
    
    func getValidMoves(position:Coordinates) -> [Coordinates] {
        guard let piece = model.board[position.row][position.column] else {return []}
 
        typealias MoveFunction = (Coordinates, BoardClass) -> [Coordinates]
        
        /*
        let getValidMovesForEachTypeOfPieces: [ChessPiece:MoveFunction] = [
            .bishop: getValidMovesBishop,
            .king: getValidMovesKing,
            .rook: getValidMovesRook,
            .knight: getValidMovesKnight,
            .pawn: getValidMovesPawn,
            .queen: getValidMovesQueen,
        ]*/
        func getValidMovesForPiece(piece: ChessPiece, position: Coordinates, board: BoardClass) -> [Coordinates] {
            switch piece {
            case .bishop:
                return getValidMovesBishop(position, board)
            case .king:
                return getValidMovesKing(position, board)
            case .rook:
                return getValidMovesRook(position, board)
            case .knight:
                return getValidMovesKnight(position, board)
            case .pawn:
                return getValidMovesPawn(position, board)
            case .queen:
                return getValidMovesQueen(position, board)
            }
        }
        
   
        
        
        //TODO: a piece could avoid a check
       /* if isKingInCheck(square: findKing(currentTurnColor, board), board) && piece.chessPiece != .king {
            return []
        }*/
        //    let typeOfPiece = piece.chessPiece
        //var validMoves: [Coordinates] = getValidMovesForEachTypeOfPieces[typeOfPiece]!(position, board)
 
        let validMoves: [Coordinates] = getValidMovesForPiece(piece: piece.chessPiece, position: position, board: board)
        let movesThatAreInCheck = getMovesThatAreInCheck(from: position, moves: validMoves, board)

        return validMoves.filter { !movesThatAreInCheck.contains($0) }
    }
    
    func getMovesThatAreInCheck(from: Coordinates, moves: [Coordinates], _ board: BoardClass) -> [Coordinates] {
         moves.filter {
            let hypotheticalBoard =  hypotheticalMove(from: from, to: $0)
            return isKingInCheck(square: findKing(currentTurnColor, hypotheticalBoard), hypotheticalBoard)
        }
    }
    
    /// Pawn Moves
    func getValidMovesPawn(_ position:Coordinates, _ board: BoardClass) -> [Coordinates] {
        var coordinates: [Coordinates] = [Coordinates]()
        
        let pieceColor = getColorsFromCoords(position, board)
        let (direction, baseRow) = pieceColor == .white ? (-1, 6) : (1, 1)
        
        if board[position.row + direction][position.column] == nil {
            coordinates.append(Coordinates(row: position.row + direction, column: position.column))
            if position.row == baseRow && board[position.row + direction * 2][position.column] == nil  {
                coordinates.append(Coordinates(row: position.row + direction * 2, column: position.column))
            }
        }
        
        /// all for en passant
        return coordinates + getThreatenedSquaresPawn(position: position, board).compactMap { $0 }.filter { coord -> Bool in
            if board[coord.row][coord.column] != nil {
                return true
            } else if let pawnMadeTwoMoves = pawnMadeTwoMovesSquare,
                      coord.row == (pawnMadeTwoMoves.row + direction) && coord.column == pawnMadeTwoMoves.column {
                return true
            }
            return false
        }
    }
    
    func getValidMovesRook(_ square: Coordinates, _ board: BoardClass) -> [Coordinates] {
        let directions = [(0,1), (1, 0), (0, -1), (-1, 0)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 7, board)
    }
    func getValidMovesBishop(_ square: Coordinates, _ board: BoardClass) -> [Coordinates] {
        let directions = [(1, 1), (1, -1), (-1, 1), (-1, -1)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 7, board)
    }
    func getValidMovesKnight(_ square: Coordinates, _ board: BoardClass) -> [Coordinates] {
        let directions = [(-1, -2), (-2, -1), (-2, 1), (-1, 2),  (1, 2), (2, 1), (2, -1), (1, -2)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 1, board)
    }
    
    func getValidMovesQueen(_ square: Coordinates, _ board: BoardClass) -> [Coordinates] {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0),(1, 1), (1, -1), (-1, 1), (-1, -1)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 7, board)
    }
    func getValidMovesKing(_ square: Coordinates, _ board: BoardClass) -> [Coordinates] {
        return getThreatenedSquaresKing(square, board) + getValidRochadeSquares(square, board)
    }
    func getThreatenedSquaresKing(_ square: Coordinates, _ board: BoardClass) -> [Coordinates] {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0),(1, 1), (1, -1), (-1, 1), (-1, -1)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 1, board)
    }

    
    func getValidRochadeSquares(_ square: Coordinates, _ board: BoardClass) -> [Coordinates] {
        var validRochadeMoves: [Coordinates] = []
        let piece = getChessPiece(square, board)
        
        if piece.chessPiece == .king {
            if piece.chessColor == .white && !model.whiteKingHasMoved {
                if !model.a1whiteRookHasMoved && isValidRochadePath(square, direction: (0, -1), maxReach: 3, board) {
                    validRochadeMoves.append(Coordinates(row: square.row, column: square.column - 2))
                }
                if !model.h1whiteRookHasMoved && isValidRochadePath(square, direction: (0, 1), maxReach: 2, board) {
                    validRochadeMoves.append(Coordinates(row: square.row, column: square.column + 2))
                }
            } else if piece.chessColor == .black && !model.blackKingHasMoved {
                if !model.a8blackRookHasMoved && isValidRochadePath(square, direction: (0, -1), maxReach: 3, board) {
                    validRochadeMoves.append(Coordinates(row: square.row, column: square.column - 2))
                }
                if !model.h8blackRookHasMoved && isValidRochadePath(square, direction: (0, 1), maxReach: 2, board) {
                    validRochadeMoves.append(Coordinates(row: square.row, column: square.column + 2))
                }
            }
            
     
        }
        
      
        return validRochadeMoves
    }
    

    
    func isValidRochadePath(_ square: Coordinates, direction: (Int, Int), maxReach: Int, _ board: BoardClass) -> Bool {
        var count = 0
        var newCoord = Coordinates(row: square.row + direction.0, column: square.column + direction.1)
        
        var kingChecked = isKingInCheck(square: square, board)
        
        

        while count < maxReach {
           
            if board[newCoord.row][newCoord.column] != nil || kingChecked {
                return false
            }
            
            
            let hypotheticalBoard = hypotheticalMove(from: square, to: newCoord)
            kingChecked = isKingInCheck(square: newCoord, hypotheticalBoard)

            
            newCoord.row += direction.0
            newCoord.column += direction.1
            count += 1
        }
        
        return true
    }
    
    
    //change to mapper
    func getValidMovesWithDirections(_ square: Coordinates, directions: [(Int,Int)], maxReach: Int, _ board: BoardClass) -> [Coordinates] {
        var validMoves: [Coordinates] = []
        guard let movingPiece = board[square.row][square.column]  else {return validMoves}
        
        for direction in directions {
            var count = 0
            var newCoord = Coordinates(row: square.row + direction.0, column: square.column + direction.1)
            
            while isValidCoordinate(cord: newCoord, color: movingPiece.chessColor, board) && count < maxReach {
                validMoves.append(newCoord)
                
                if board[newCoord.row][newCoord.column] != nil {break}
                
                newCoord.row += direction.0
                newCoord.column += direction.1
                count += 1
                
            }
        }
        return validMoves
    }
    
    func getThreatenedSquaresPawn(position:Coordinates, _ board: BoardClass) -> [Coordinates] {
        let directions = (board[position.row][position.column]?.chessColor == .white) ? [(-1, -1), (-1, 1)] : [(1, -1), (1, 1)]
        return getValidMovesWithDirections(position, directions: directions, maxReach: 1, board)
    }
    
    func transformPawn(square:Coordinates, _ board: BoardClass) -> Void {
        let piece =  Piece(chessPiece: .queen, chessColor: getColorsFromCoords(square, board))
        model.board[square.row][square.column] = piece
    }
    
    /// validates that coordinates are on the board and the square there is not a piece with the same color
    func isValidCoordinate(cord: Coordinates, color: ChessColor, _ board: BoardClass) -> Bool {
        return cord.row >= 0 && cord.row < 8 && cord.column >= 0 && cord.column < 8 && color != board[cord.row][cord.column]?.chessColor
    }
    
    func getColorsFromCoords(_ coords:Coordinates,_ board: BoardClass) -> ChessColor {
        board[coords.row][coords.column]!.chessColor
    }
    
    func getChessPiece(_ square: Coordinates, _ board: BoardClass) -> Piece {
        board[square.row][square.column]!
    }
    
    
    func isKingInCheck(square: Coordinates, _ board: BoardClass) -> Bool {
        let kingColor = getColorsFromCoords(square, board)
        let opponentColor: ChessColor = kingColor == .white ? .black : .white

        if pieceIsOnSquares(squares: getValidMovesRook(square, board), piece: Piece(chessPiece: .rook, chessColor: opponentColor), board) {
            return true
        }

        if pieceIsOnSquares(squares: getValidMovesBishop(square, board), piece: Piece(chessPiece: .bishop, chessColor: opponentColor), board) {
            return true
        }

        if pieceIsOnSquares(squares: getValidMovesKnight(square, board), piece: Piece(chessPiece: .knight, chessColor: opponentColor), board) {
            return true
        }

        if pieceIsOnSquares(squares: getThreatenedSquaresPawn(position: square, board), piece: Piece(chessPiece: .pawn, chessColor: opponentColor), board) {
            return true
        }
        if pieceIsOnSquares(squares: getValidMovesQueen(square, board), piece: Piece(chessPiece: .queen, chessColor: opponentColor), board) {
            return true
        }

        if pieceIsOnSquares(squares: getThreatenedSquaresKing(square, board), piece: Piece(chessPiece: .king, chessColor: opponentColor), board) {
            return true
        }

        return false
    }
    
    func pieceIsOnSquares(squares: [Coordinates], piece: Piece, _ board: BoardClass) -> Bool {
        return squares.contains { board[$0.row][$0.column] == piece }
    }
    
    
    func findKing(_ color: ChessColor, _ board: BoardClass) -> Coordinates {
        findPiece(pieceToFind: Piece(chessPiece: .king, chessColor: color), board)!
    }
    
    func findPiece(pieceToFind: Piece, _ board: BoardClass) -> Coordinates? {
        for (row, rowPieces) in board.enumerated() {
            if let column = rowPieces.firstIndex(where: { $0 == pieceToFind }) {
                return Coordinates(row: row, column: column)
            }
        }
        return nil
    }
    
    
    
    
    
    
}
/**
 
 */
