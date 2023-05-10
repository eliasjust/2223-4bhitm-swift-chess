//
//  Model.swift
//  chess
//
//  Created by Elias Just on 28.03.23.
//

import Foundation

struct Model {
    
    
    var blackBeatenPieces: [Piece]  =  []
    var whiteBeatenPieces:  [Piece] = []
    var currentTurnColor:ChessColor  = .white
    typealias BoardClass = [[Piece?]]
    var board: BoardClass
    
    var a8blackRookHasMoved: Bool = false
    var h8blackRookHasMoved: Bool = false
    var a1whiteRookHasMoved: Bool = false
    var h1whiteRookHasMoved: Bool = false
    var whiteKingHasMoved: Bool = false
    var blackKingHasMoved: Bool = false
    
    var isDraw: Bool = false
    var isCheckMate: ChessColor?
    
    enum ChessPiece: String {
        case king
        case queen
        case rook
        case bishop
        case knight
        case pawn
    }
    
    enum ChessColor: String {
        case black, white
    }
    
    
    init() {
        //is going to be replaced by GBR-Code or VEN
        
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
    
    struct Piece: Equatable,Hashable {
        var chessPiece: ChessPiece
        var chessColor: ChessColor
    }
    
    
    
}

