//
//  Strategies.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation


class AllStrategies {
    
    static  let viewmodel  = ViewModel()
    
    
    typealias StrategyForEachChessType = [ViewModel.ChessPiece: (ViewModel.Coordinates,ViewModel.BoardClass) -> [ViewModel.Coordinates]]
    
      static func getValidMoves(_ position: ViewModel.Coordinates, _ board: Model.BoardClass) -> [ViewModel.Coordinates] {
        let pieceType = viewmodel.getChessPiece(position, board).chessPiece
       
        let strategyForChessType: StrategyForEachChessType = [
          
          
            
          
            :
        ]
        
        return []
        
    }
    
    
    static func getThreatenPieces(_ position: ViewModel.Coordinates, _ board: Model.BoardClass ) -> [ViewModel.Coordinates] {
        let pieceType = viewmodel.getChessPiece(position, board).chessPiece
       
        let strategyForChessType: StrategyForEachChessType = [:
        
        ]
        
        return []
        
    }
    
    
}
