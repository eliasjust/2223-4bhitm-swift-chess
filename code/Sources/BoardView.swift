//
//  BoardView.swift
//  chess
//
//  Created by Elias Just on 15.03.23.
//

import SwiftUI


struct BoardView: View {
    let boardSize: CGFloat = 320 // size of board
    let tileSize: CGFloat = 40 // size of each tile
    
    let colorWhite = Color.white
    let colorBlack = Color.black
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<8) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8) { column in
                        Rectangle()
                            .fill((row + column) % 2 == 0 ? colorWhite : colorBlack)
                            .frame(width: tileSize, height: tileSize)
                    }
                }
            }
        }
        .frame(width: boardSize, height: boardSize)
    }
}
