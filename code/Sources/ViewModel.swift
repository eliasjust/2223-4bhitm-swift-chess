//
//  ViewModel.swift
//  chess
//
//  Created by Elias Just on 21.03.23.
//

import Foundation

import Combine

class ViewModel: ObservableObject {
    
    typealias Piece = Model.Piece
    typealias ChessColor = Model.ChessColor
    var fromSquare: Coordinates? = nil
    var toSquare: Coordinates? = nil
    
    var currentTurnColor: ChessColor = .white
    ///needed for en passant
    var pawnMadeTwoMoves: Coordinates? = nil
    var predictions: [Coordinates?] = []
    
    struct Coordinates: Equatable {
        var  row: Int
        var column: Int
    }
    
    func clearValues () {
        fromSquare = nil
        toSquare = nil
    }
    typealias ChessPiece = Model.ChessPiece
    
    func setCoordinates (row: Int, column: Int) -> Coordinates {
        return Coordinates(row: row, column: column)
    }
    
    func checkIfAreaIsTapped() -> Bool {
        return fromSquare != nil
    }
    func checkIfPiecesShouldBeDrawnAgain() -> Bool {
        return fromSquare != nil && toSquare != nil
    }
    func clearTapSetting() {
        fromSquare = nil
        toSquare = nil
    }
    
    
    
    //is going to be replaced by GBR-Code or VEN
    @Published private(set) var model =  Model()
    
    
    typealias BoardClass = [[Piece?]]
    
    var board: BoardClass {
        model.board
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
            handleMove(fromPosition: fromSquare!, toPosition: tappedPosition)
        }
        
    }
    
    
    func handleMove(fromPosition:Coordinates, toPosition:Coordinates?) -> Void {
        if moveIsValid(fromPosition: fromPosition, toPosition: toPosition!) {
            if board[fromPosition.row][fromPosition.column]!.chessPiece == .pawn {
                pawnMoves(fromSquare: fromPosition, toSquare:  toPosition!)
            }else {
                pawnMadeTwoMoves = nil
            }
            
            if let piece = board[toPosition!.row][toPosition!.column] {
                capturePiece(piece: piece)
            }
            movePiece(from: fromPosition, to: toPosition!)
        }
        
    }
    
    func movePiece(from:Coordinates, to:Coordinates) -> Void {
        model.board[to.row][to.column] = board[from.row][from.column]
        model.board[from.row][from.column] = nil
        currentTurnColor = (currentTurnColor == .white) ? .black : .white
    }
    
    func capturePiece(piece:Piece) -> Void {
        return
    }
    
    func pawnMoves(fromSquare:Coordinates, toSquare:Coordinates ) -> Void {
        if toSquare.row == 0 || toSquare.row == 7  {
            transformPawn(square: fromSquare)
        }
        
        if fromSquare.column != toSquare.column && board[toSquare.row][toSquare.column] == nil {
            captureEnPasant(square: pawnMadeTwoMoves!)
        }
        pawnMadeTwoMoves = nil

        /// pawn moved two squares
        if fromSquare.row == 1 && toSquare.row == 3 || fromSquare.row == 6 && toSquare.row == 4 {
            pawnMadeTwoMoves = toSquare
        }
    
        
    }
    
    func captureEnPasant(square:Coordinates) -> Void {
        let piece = board[square.row][square.column]
        model.board[square.row][square.column] = nil
        capturePiece(piece: piece!)
    }

    
    func moveIsValid(fromPosition:Coordinates, toPosition:Coordinates) -> Bool {
        return getValidMoves(position: fromPosition).contains(where: {$0!.column == toPosition.column && $0!.row == toPosition.row})
        
    }
    
    func getValidMoves(position:Coordinates) -> [Coordinates?] {
         let piece = model.board[position.row][position.column]
        if piece == nil {
            return [toSquare]
        } else {
        
        typealias MoveFunction = (Coordinates) -> [Coordinates?]
        
        let getValidMovesForEachTypeOfPieces: [ChessPiece:MoveFunction] = [
            .bishop: getValidMovesBishop,
            .king: getValidMovesKing,
            .rook: getValidMovesRook,
            .knight: getValidMovesKnight,
            .pawn: getValidMovesPawn,
            .queen: getValidMovesQueen,
        ]
            let typeOfPiece = piece!.chessPiece
            guard let moveHandler = getValidMovesForEachTypeOfPieces[typeOfPiece] else { return [toSquare] }
            return moveHandler(position)
        }

        
    }

    
    func getValidMovesPawn(position:Coordinates) -> [Coordinates?] {
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
    

    func getThreatenedSquaresPawn(position:Coordinates) -> [Coordinates?] {
        let directions = (board[position.row][position.column]?.chessColor == .white) ? [(-1, -1), (-1, 1)] : [(1, -1), (1, 1)]
        return getValidMovesWithDirections(position, directions: directions, maxReach: 1)
    }
    
    
    
    func transformPawn(square:Coordinates?) -> Void {
        let piece =  Piece(chessPiece: .queen, chessColor: getColorsFromCoords(coords: square!))
        model.board[square!.row][square!.column] = piece
    }
    
 
    
    func getValidMovesRook(_ square:Coordinates) -> [Coordinates?] {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 7)
    }
    func getValidMovesBishop(_ square:Coordinates) -> [Coordinates?] {
        let directions = [(1, 1), (1, -1), (-1, 1), (-1, -1)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 7)
    }
    func getValidMovesKnight(_ square:Coordinates) -> [Coordinates?] {
        let directions = [(-1, -2), (-2, -1), (-2, 1), (-1, 2),  (1, 2), (2, 1), (2, -1), (1, -2)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 1)
    }
    
    func getValidMovesQueen(_ square: Coordinates) -> [Coordinates?] {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0),(1, 1), (1, -1), (-1, 1), (-1, -1)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 7)
    }
    func getValidMovesKing(_ square:Coordinates) -> [Coordinates?] {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0),(1, 1), (1, -1), (-1, 1), (-1, -1)]
        return getValidMovesWithDirections(square, directions: directions, maxReach: 1)
    }
    
    
    func getValidMovesWithDirections(_ square: Coordinates, directions: [(Int,Int)], maxReach: Int) -> [Coordinates?] {
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
    func isValidCoordinate(cord: Coordinates, color: ChessColor) -> Bool {
        return cord.row >= 0 && cord.row < 8 && cord.column >= 0 && cord.column < 8 && color != board[cord.row][cord.column]?.chessColor
    }
    
    func getColorsFromCoords(coords:Coordinates) -> ChessColor {
        board[coords.row][coords.column]!.chessColor
    }
    
    
    
    
}
/**
 
 */
