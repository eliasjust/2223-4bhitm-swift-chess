//
//  MoveStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation

protocol Rule {
    func validMoves(_ position: ViewModel.Coordinates, _ board: Model.BoardClass) -> [ViewModel.Coordinates]
}
