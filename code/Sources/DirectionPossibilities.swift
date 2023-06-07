//
//  DirectionPossibilities.swift
//  chess
//
//  Created by BHITM01 on 06.06.23.
//

import Foundation


struct Direction {
    
    var x: Int
    var y:Int
}


enum DirectionType:Equatable {
    case vertical,
         horizontal,
         diagonal,
         knight
    
}



fileprivate var allPossibleMovesDirections:[DirectionType:[Direction]] = [
    .vertical : [Direction(x:0,y:1), Direction(x:0, y: -1)],
    .horizontal: [Direction(x: 1, y:0), Direction(x:-1, y:0)],
    .diagonal : [Direction(x: 1, y: 1), Direction(x: 1, y: -1), Direction(x: -1, y: 1), Direction(x: -1, y: -1)],
    .knight: [
        Direction(x: -1, y: -2),
        Direction(x: -1, y: 2),
        Direction(x: -2, y: -1),
        Direction(x:-2, y: 1),
        Direction(x:1, y: 2),
        Direction(x:1, y: -2),
        Direction(x:2, y: -1),
        Direction(x:2, y: 1)]

]


var allDirections = allPossibleMovesDirections[.vertical]! + allPossibleMovesDirections[.horizontal]! + allPossibleMovesDirections[.diagonal]!

var moveDirectionsForPiece: [Model.ChessPiece:[Direction]]  = [

    .king: allDirections,
    .queen: allDirections,
    .bishop: allPossibleMovesDirections[.diagonal]!,
    .knight: allPossibleMovesDirections[.knight]!,
    .rook: allPossibleMovesDirections[.horizontal]! + allPossibleMovesDirections[.vertical]!
]
