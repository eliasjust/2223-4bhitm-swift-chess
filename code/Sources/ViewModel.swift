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
    var previousColor:CGColor? = nil
    
    struct Coordinates  {
        var  row: Int
        var column: Int
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
    @Published private(set) var model =  Model(board: [
        [Piece(chessPiece: .rook, chessColor: .black), Piece(chessPiece: .knight, chessColor: .black), Piece(chessPiece: .bishop, chessColor: .black), Piece(chessPiece: .queen, chessColor: .black), Piece(chessPiece: .king, chessColor: .black), Piece(chessPiece: .bishop, chessColor: .black), Piece(chessPiece: .knight, chessColor: .black), Piece(chessPiece: .rook, chessColor: .black)],
        [Piece(chessPiece: .pawn, chessColor: .black), Piece(chessPiece: .pawn, chessColor: .black), Piece(chessPiece: .pawn, chessColor: .black), Piece(chessPiece: .pawn, chessColor: .black), Piece(chessPiece: .pawn, chessColor: .black), Piece(chessPiece: .pawn, chessColor: .black), Piece(chessPiece: .pawn, chessColor: .black), Piece(chessPiece: .pawn, chessColor: .black)],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [Piece(chessPiece: .pawn, chessColor: .white), Piece(chessPiece: .pawn, chessColor: .white), Piece(chessPiece: .pawn, chessColor: .white), Piece(chessPiece: .pawn, chessColor: .white), Piece(chessPiece: .pawn, chessColor: .white), Piece(chessPiece: .pawn, chessColor: .white), Piece(chessPiece: .pawn, chessColor: .white), Piece(chessPiece: .pawn, chessColor:  .white)],
        
        [Piece(chessPiece: .rook, chessColor: .white), Piece(chessPiece: .knight, chessColor: .white), Piece(chessPiece: .bishop, chessColor: .white), Piece(chessPiece: .queen, chessColor: .white), Piece(chessPiece: .king, chessColor:  .white), Piece(chessPiece: .bishop, chessColor: .white), Piece(chessPiece: .knight, chessColor: .white), Piece(chessPiece: .rook, chessColor: .white)],
    ])
    
    
    typealias BoardClass = [[Piece?]]
    
    var board: BoardClass {
        model.board
    }
    
    func handleMove(data:Coordinates) -> Void {
        print("toPosition \(toPosition)")
        print(fromPosition)
        let pieceAtGivenCoordinates = board[data.row][data.column]
        if pieceAtGivenCoordinates == nil && fromPosition == nil {
            return
        }
        
        if fromPosition == nil && pieceAtGivenCoordinates != nil {
            fromPosition = data
        } else if fromPosition != nil && toPosition == nil {
            toPosition = data
            
            
            let piece = board[fromPosition!.row][fromPosition!.column]
            model.board[fromPosition!.row][fromPosition!.column] = nil
            model.board[toPosition!.row][toPosition!.column] = piece
            
        }
        
        
        
        
    }
    
    
}
/**
 
 */
