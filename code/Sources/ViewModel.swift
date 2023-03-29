//
//  ViewModel.swift
//  chess
//
//  Created by Elias Just on 21.03.23.
//

import Foundation
import SwiftUI


let squareSize = 40.0
class ViewModel: ObservableObject {
    
    //is going to be replaced by GBR-Code
    @Published private var model =  Model(board: [
        [(.rook, .black), (.knight, .black), (.bishop, .black), (.queen, .black), (.king, .black), (.bishop, .black), (.knight, .black), (.rook, .black)],
        [(.pawn, .black), (.pawn, .black), (.pawn, .black), (.pawn, .black), (.pawn, .black), (.pawn, .black), (.pawn, .black), (.pawn, .black)],
        [(nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil),(nil, nil), (nil, nil)],
        [(nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil)],
        [(nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil)],
        [(nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil), (nil, nil)],
        [(.pawn, .white), (.pawn, .white), (.pawn, .white), (.pawn, .white), (.pawn, .white), (.pawn, .white), (.pawn, .white), (.pawn, .white)],
        [(.rook, .white), (.knight, .white), (.bishop, .white), (.queen, .white), (.king, .white), (.bishop, .white), (.knight, .white), (.rook, .white)],
    ])
    
    var board:[[(piece: Model.ChessPiece?, color: Model.ChessColor?)]]{
        model.board
    }
    
    
}
