//
//  MoveStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation

protocol MoveStrategy {
    func getValidMoves(_ position: ViewModel.Coordinates, _ board: Model.BoardClass) -> [ViewModel.Coordinates]
}
