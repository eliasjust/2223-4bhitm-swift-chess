//
//  ThreatStrategy.swift
//  chess
//
//  Created by BHITM01 on 24.05.23.
//

import Foundation


protocol ThreatRule {
    func getThreatenPieces(_ position: ViewModel.Coordinates, _ board: ViewModel.BoardClass) -> [ViewModel.Coordinates]
}
