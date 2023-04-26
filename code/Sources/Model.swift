//
//  Model.swift
//  chess
//
//  Created by Elias Just on 28.03.23.
//

import Foundation

struct Model {
    
    typealias BoardClass = [[Piece?]]
    var board: BoardClass
    
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
    
    
    init() {
        
        func createPieces(_ type:ChessPiece) -> (Piece, Piece) {
            return (Piece(chessPiece: type, chessColor: .black),
                    Piece(chessPiece: type, chessColor: .white))
        }
        
        let emptyRow = Array<Piece?>(repeating: nil, count: 8)
        let whitePawns = Array<Piece?>(repeating: Piece(chessPiece: .pawn, chessColor: .white), count: 8)
        let blackPawns = Array<Piece?>(repeating: Piece(chessPiece: .pawn, chessColor: .black), count: 8)
        let (blackKnight, whiteKnight) = createPieces(.knight)
        let (blackRook, whiteRook) = createPieces(.rook)
        let (blackBishop, whiteBishop) = createPieces(.bishop)
        let (blackQueen, whiteQueen) = createPieces(.queen)
        let (blackKing, whiteKing) = createPieces(.king)
        
        self.board = [
            [blackRook, blackKnight, blackBishop, blackQueen, blackKing, blackBishop, blackKnight, blackRook],
            blackPawns,
            emptyRow,
            emptyRow,
            emptyRow,
            emptyRow,
            whitePawns,
            [whiteRook, whiteKnight, whiteBishop, whiteQueen, whiteKing, whiteBishop, whiteKnight, whiteRook],
        ]
    }
    
    struct Piece {
        var chessPiece: ChessPiece
        var chessColor: ChessColor
    }
}

