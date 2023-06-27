//
//  BoardBuilder.swift
//  chess
//
//  Created by Elias Just on 27.06.23.
//

import Foundation

struct BoardBuilder {
    
    typealias Piece = Model.Piece
    typealias ChessPiece = Model.ChessPiece
    typealias ChessColor = Model.ChessColor
    typealias BoardClass = Model.BoardClass
  
    
    
    let emptyRow = Array<Piece?>(repeating: nil, count: 8)
    let empty: Piece?
    let whitePawns = Array<Piece?>(repeating: Piece(chessPiece: .pawn, chessColor: .white), count: 8)
    let blackPawns = Array<Piece?>(repeating: Piece(chessPiece: .pawn, chessColor: .black), count: 8)
    let blackPawn = Piece(chessPiece: .pawn, chessColor: .black)
    let whitePawn = Piece(chessPiece: .pawn, chessColor: .white)
    let (blackKnight, whiteKnight): (Piece, Piece)
    let (blackRook, whiteRook): (Piece, Piece)
    let (blackBishop, whiteBishop): (Piece, Piece)
    let (blackQueen, whiteQueen): (Piece, Piece)
    let (blackKing, whiteKing): (Piece, Piece)
    
    init() {
        
        func createPieces(_ type:ChessPiece) -> (Piece, Piece) {
            return (Piece(chessPiece: type, chessColor: .black),
                    Piece(chessPiece: type, chessColor: .white))
        }
        (blackKnight, whiteKnight) = createPieces(.knight)
        (blackRook, whiteRook) = createPieces(.rook)
        (blackBishop, whiteBishop) = createPieces(.bishop)
        (blackQueen, whiteQueen) = createPieces(.queen)
        (blackKing, whiteKing) = createPieces(.king)
        empty = nil
    }
    
     func checkMateTemplate() -> BoardClass {
        [
            [blackRook, empty, empty, empty, blackKing, empty, blackBishop, blackRook],
            [empty, blackPawn, empty, empty, empty, blackPawn, blackPawn, blackPawn],
            [empty, empty, empty, empty, empty, empty, empty, empty],
            [empty, empty, blackPawn, empty, blackPawn, empty, empty, empty],
            [empty, empty, whitePawn, empty, empty, empty, empty, empty],
            [empty, empty, empty, empty, empty, empty, empty, empty],
            [empty, whitePawn, empty, empty, empty, whitePawn, whitePawn, whitePawn],
            [whiteRook, empty, empty, empty, whiteKing, whiteBishop, empty, whiteRook],
        ]
    }
    
    func promotePawnTemplate() -> BoardClass {
        [
            [blackRook, empty, empty, blackQueen, blackKing, empty, blackBishop, blackRook],
            [empty, whitePawn, empty, empty, empty, blackPawn, blackPawn, blackPawn],
            [empty, empty, empty, empty, empty, empty, empty, empty],
            [empty, empty, blackPawn, empty, blackPawn, empty, empty, empty],
            [empty, empty, whitePawn, empty, empty, empty, empty, empty],
            emptyRow,
            [empty, whitePawn, empty, empty, empty, whitePawn, whitePawn, whitePawn],
            [whiteRook, empty, empty, whiteQueen, whiteKing, whiteBishop, empty, whiteRook],
        ]
    }
    
    func rochadeTemplate() -> BoardClass {
        [
            [blackRook, blackKnight, blackBishop, empty, blackKing, blackBishop, blackKnight, blackRook],
            [blackPawn, blackPawn, blackPawn, empty, blackPawn, blackPawn, blackPawn, blackPawn],
            emptyRow,
            [empty, empty, blackQueen, empty, empty, empty, empty, empty],
            emptyRow,
            emptyRow,
            [whitePawn, whitePawn, empty, whitePawn, empty, whitePawn, whitePawn, whitePawn],
            [whiteRook, empty, empty, empty, whiteKing, empty, empty, whiteRook],
        ]
    }
    
    func enPassantTemplate() -> BoardClass {
        [
            [blackRook, blackKnight, blackBishop, blackQueen, blackKing, blackBishop, blackKnight, blackRook],
            blackPawns,
            emptyRow,
            emptyRow,
            emptyRow,
            emptyRow,
            whitePawns,
            [whiteRook, whiteKnight, whiteBishop, empty, whiteKing, whiteBishop, whiteKnight, whiteRook],
        ]
    }



}
