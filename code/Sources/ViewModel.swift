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
    
    //is going to be replaced by GBR-Code
    @Published private var model =  Model(board: [
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
    
    
}
/**
 
 */
