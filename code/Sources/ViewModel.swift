//
//  ViewModel.swift
//  chess
//
//  Created by Elias Just on 21.03.23.
//

import Foundation
import SwiftUI
import Combine

class ViewModel: ObservableObject {
    
    typealias Piece = Model.Piece
    var fromPosition: Coordinates? = nil
    var toPosition:Coordinates? = nil
    var previousColor:UIColor? = nil
    
    struct Coordinates  {
        var  row: Int
        var column: Int
    }
    
    func clearValues () {
        fromPosition = nil
        toPosition = nil
    }
    
    
    func setCoordinates (row: Int, column: Int) -> Coordinates {
        return Coordinates(row: row, column: column)
    }
    
    func checkIfAreaIsTapped() -> Bool {
        return fromPosition != nil
    }
    func checkIfPiecesShouldBeDrawnAgain () -> Bool {
        return fromPosition != nil && toPosition != nil
    }
    func clearTapSetting() {
        fromPosition = nil
        toPosition = nil
    }
    
    
    
    //is going to be replaced by GBR-Code or VEN
    @Published private(set) var model =  Model()
    
    
    typealias BoardClass = [[Piece?]]
    
    var board: BoardClass {
        model.board
    }
    
    func handleTap(tappedPosition:Coordinates) -> Void {
        
        let pieceAtGivenCoordinates = board[tappedPosition.row][tappedPosition.column]
        if pieceAtGivenCoordinates != nil || fromPosition != nil {
            
            if fromPosition == nil && pieceAtGivenCoordinates != nil {
                fromPosition = tappedPosition
            } else if fromPosition != nil && toPosition == nil {
                toPosition = tappedPosition
                handleMove(fromPosition: fromPosition!, toPosition: tappedPosition)
            }
        }
        
        
        
    }
    
    
    func handleMove(fromPosition:Coordinates, toPosition:Coordinates?) -> Void {
        let movingPiece = board[fromPosition.row][fromPosition.column]
        let toSquare = toPosition
        if moveIsValid(fromPosition: fromPosition, toPosition: toPosition!) {
            model.board[fromPosition.row][fromPosition.column] = nil
            model.board[toPosition!.row][toPosition!.column] = movingPiece
            
            
            if (toSquare!.row == 0 || toSquare!.row == 7 ) && movingPiece!.chessPiece == .pawn {
                transformPawn(square: toSquare!)
            }
        }
        
    }
    
    func moveIsValid(fromPosition:Coordinates, toPosition:Coordinates) -> Bool {
        return getValidMoves(position: fromPosition).contains(where: {$0!.column == toPosition.column && $0!.row == toPosition.row})
        
    }
    
    func getValidMoves(position:Coordinates) -> [Coordinates?] {
        let piece = model.board[position.row][position.column]
        
        if piece?.chessPiece == .pawn && piece?.chessColor == .white {
            return getValidMovesWhitePawn(position: position)
            
        }else if piece?.chessPiece == .pawn && piece?.chessColor == .black {
            return getValidMovesBlackPawn(position: position)
        }else if piece?.chessPiece == .rook {
            return getValidMovesRook(square: position)
        }else if piece?.chessPiece == .bishop {
            return getValidMovesBishop(square: position)
        }else if piece?.chessPiece == .knight {
            return getValidMovesKnight(square: position)
        }else if piece?.chessPiece == .queen {
            return getValidMovesQueen(square: position)
        }else if piece?.chessPiece == .king {
            return getValidMovesKing(square: position)
        }
        
        
        return [toPosition]
        
    }
    
    func getValidMovesWhitePawn(position:Coordinates) -> [Coordinates?] {
        var coordinates: [Coordinates?] = [Coordinates]()
        
        if board[position.row-1][position.column] == nil {
            coordinates.append(Coordinates(row: position.row-1, column: position.column))
            if position.row==6 && board[position.row-2][position.column] == nil  {
                coordinates.append(Coordinates(row: position.row-2, column: position.column))
            }
        }
        return coordinates + getThreatenedSquaresPawn(position: position).filter({board[$0!.row][$0!.column] != nil})
    }
    
    func getValidMovesBlackPawn(position:Coordinates) -> [Coordinates?] {
        var coordinates: [Coordinates?] = [Coordinates]()
        
        
        if board[position.row+1][position.column] == nil {
            coordinates.append(Coordinates(row: position.row+1, column: position.column))
            
            if position.row==1 && board[position.row+2][position.column] == nil  {
                coordinates.append(Coordinates(row: position.row+2, column: position.column))
            }
        }
        
        return coordinates + getThreatenedSquaresPawn(position: position).filter({board[$0!.row][$0!.column] != nil})
    }
    
    func getThreatenedSquaresPawn(position:Coordinates) -> [Coordinates?] {
        
        let directions = (board[position.row][position.column]?.chessColor == .white) ? [(-1, -1), (-1, 1)] : [(1, -1), (1, 1)]
       
        return getValidMovesWithDirections(square: position, directions: directions, maxReach: 1)
    }
    
    
    
    func transformPawn(square:Coordinates?) -> Void {
        let piece =  Piece(chessPiece: .queen, chessColor: board[square!.row][square!.column]!.chessColor)
        model.board[square!.row][square!.column] = piece
    }
    
    
    func getValidMovesRook(square:Coordinates) -> [Coordinates?] {
        return getValidMovesWithDirections(square: square, directions: [(0, 1), (1, 0), (0, -1), (-1, 0)], maxReach: 7)
    }
    func getValidMovesBishop(square:Coordinates) -> [Coordinates?] {
        return getValidMovesWithDirections(square: square, directions: [(1, 1), (1, -1), (-1, 1), (-1, -1)], maxReach: 7)
    }
    func getValidMovesKnight(square:Coordinates) -> [Coordinates?] {
        let directions = [(-1, -2), (-2, -1), (-2, 1), (-1, 2),  (1, 2), (2, 1), (2, -1), (1, -2)]
        var validMoves: [Coordinates] = []
        
        for direction in directions {
            let newCord = Coordinates(row: square.row + direction.0, column: square.column + direction.1)
            
            if isValidCoordinate(cord: newCord, color: board[square.row][square.column]!.chessColor) {
                validMoves.append(newCord)
            }
            
        }
        return validMoves
    }
    
    func getValidMovesQueen(square: Coordinates) -> [Coordinates?] {
        return getValidMovesWithDirections(square: square, directions: [(0, 1), (1, 0), (0, -1), (-1, 0),(1, 1), (1, -1), (-1, 1), (-1, -1)], maxReach: 7)
    }
    func getValidMovesKing(square:Coordinates) -> [Coordinates?] {
        return getValidMovesWithDirections(square: square, directions: [(0, 1), (1, 0), (0, -1), (-1, 0),(1, 1), (1, -1), (-1, 1), (-1, -1)], maxReach: 1)
    }
    
    
    func getValidMovesWithDirections(square: Coordinates, directions: [(Int,Int)], maxReach: Int) -> [Coordinates?] {
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
    func isValidCoordinate(cord: Coordinates, color: Model.ChessColor) -> Bool {
        return cord.row >= 0 && cord.row < 8 && cord.column >= 0 && cord.column < 8 && color != board[cord.row][cord.column]?.chessColor
    }
    
    
    
    
}
/**
 
 */
