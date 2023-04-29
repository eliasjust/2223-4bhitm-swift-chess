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
            return getValidMovesBlackPawns(position: position)
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
        return coordinates
    }
    
    func getValidMovesBlackPawns(position:Coordinates) -> [Coordinates?] {
        var coordinates: [Coordinates?] = [Coordinates]()
        
        
            if board[position.row+1][position.column] == nil {
                coordinates.append(Coordinates(row: position.row+1, column: position.column))
                
                if position.row==1 && board[position.row+2][position.column] == nil  {
                    coordinates.append(Coordinates(row: position.row+2, column: position.column))
                }
            }
        
        return coordinates
    }
    
    
    func transformPawn(square:Coordinates?) -> Void {
        let piece =  Piece(chessPiece: .queen, chessColor: board[square!.row][square!.column]!.chessColor)
        model.board[square!.row][square!.column] = piece
    }
    
    
    
    
    
    
    
}
/**
 
 */
