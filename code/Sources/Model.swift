//
//  Model.swift
//  chess
//
//  Created by Elias Just on 28.03.23.
//

import Foundation

struct Model {

    var board: [[(piece: ChessPiece?, color: ChessColor?)]]

    enum ChessPiece: String {
        case king = "K"
        case queen = "Q"
        case rook = "R"
        case bishop = "B"
        case knight = "N"
        case pawn = "P"
    }
    
    enum ChessColor {
        case black, white
    }

    init(board: [[(piece: ChessPiece?, color: ChessColor?)]]) {
        self.board = board
    }

    
    /*
    struct Piece {
        var chessPiece: ChessPiece
        var chessColor: ChessColor
    }
     */

}

