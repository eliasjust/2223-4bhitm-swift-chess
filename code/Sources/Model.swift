//
//  Model.swift
//  chess
//
//  Created by Elias Just on 28.03.23.
//

import Foundation

struct Model {
    static let DATABASE = "http://localhost:3000/board"

    var playerIsColor: ChessColor = .white
    var initialGameState: Bool = true
    
    var blackBeatenPieces: [Piece]  =  []
    var whiteBeatenPieces:  [Piece] = []
    var currentTurnColor:ChessColor  = .white
    typealias BoardClass = [[Piece?]]
    var board: BoardClass
    
    struct PieceDto: Codable, Hashable {
        var chessColor: String
        var chessPiece: String
    }
    
    var a8blackRookHasMoved: Bool = false
    var h8blackRookHasMoved: Bool = false
    var a1whiteRookHasMoved: Bool = false
    var h1whiteRookHasMoved: Bool = false
    var whiteKingHasMoved: Bool = false
    var blackKingHasMoved: Bool = false
    var blackKingPosition: ViewModel.Coordinates = ViewModel.Coordinates(row: 0, column: 4)
    var whiteKingPosition: ViewModel.Coordinates = ViewModel.Coordinates(row: 7, column: 4)
    
    var pawnMadeTwoMovesSquare: ViewModel.Coordinates? = nil
    
    
    var isDraw: Bool = false
    var isCheckMate: ChessColor?
    var pawnPromotes: Coordinate? = nil
    enum ChessPiece: String, CaseIterable {
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
    
    struct Piece: Equatable, Hashable {
        var chessPiece: ChessPiece
        var chessColor: ChessColor
       
    }
    
    struct Coordinate: Equatable {
        var row: Int
        var column: Int
    }
    
    mutating func updateBoardFromJson(data: Data) {
      
        /*
         
         print json to string:
        do {
            print(try JSONSerialization.jsonObject(with: data, options: [])  )

        } catch {
            
            print("can not convert")
        }
         
         
         
         print array to json:
        var testBoard: [[PieceDto]] = [[
            PieceDto(chessColor: "test2", chessPiece: "test2")
        ]]
            

        do {
            let jsonData = try JSONEncoder().encode(testBoard)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            print("Error converting array to JSON: \(error.localizedDescription)")
        }
         
         
        */
        if let databaseBoard = try? JSONDecoder().decode([[PieceDto?]].self, from: data){
            
            var finalBoard: BoardClass = Array(repeating: Array(repeating: nil, count: 8), count: 8)
            for (i, row) in databaseBoard.enumerated() {
                for (j, col) in row.enumerated() {
                    if let pieceString = col {
                        if let chessPiece = Model.ChessPiece(rawValue: pieceString.chessPiece),
                           let chessColor = Model.ChessColor(rawValue: pieceString.chessColor) {
                            
                            
                            let validPiece = Piece(chessPiece: chessPiece, chessColor: chessColor)
                            finalBoard[i][j] = validPiece
                        }else {
                            finalBoard[i][j] = nil
                        }
                    }

                }
            }
            board = finalBoard
        }
    }
    

    
}

