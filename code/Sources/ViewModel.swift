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
    
    func handleMove(data:Coordinates) -> Void {
        
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
