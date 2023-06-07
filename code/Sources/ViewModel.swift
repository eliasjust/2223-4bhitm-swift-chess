//
//  ViewModel.swift
//  chess
//
//  Created by Elias Just on 21.03.23.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published private(set) var model =  Model()
    
    typealias Piece = Model.Piece
    typealias ChessColor = Model.ChessColor
    typealias ChessPiece = Model.ChessPiece
    typealias Coordinates = Model.Coordinate
    let defaultBlackKingPos = Coordinates(row: 0, column: 4)
    
    let defaultWhiteKingPos = Coordinates(row: 7, column: 4)
    
    var initialGameState: Bool {
        model.initialGameState
    }

    
    var playerIsColor: ChessColor {
        model.playerIsColor
    }
    
    var whiteBeatenPieces: [Piece] {
        model.whiteBeatenPieces
    }
    var blackBeatenPieces: [Piece] {
        model.blackBeatenPieces
    }
        
    var blackIsCheckMate:Bool {
        model.isCheckMate == .black
        
    }
    var whiteIsCheckMate:Bool {
        model.isCheckMate == .white
    }
    
    
    var gameIsEnded:Bool {
        model.isCheckMate != nil || model.isDraw == true
    }
    
    
    
    var pawnPromotes:Coordinates? {
        model.pawnPromotes
    }
    
    typealias BoardClass = [[Piece?]]
    
    var board: BoardClass {
        model.board
    }
    
    var currentTurnColor: ChessColor = .white
    ///needed for en passant
    var pawnMadeTwoMovesSquare: Coordinates? = nil
    
    
    func isKingInCheck(position: Coordinates) -> Bool {
      return  KingRule(model:model,color:model.currentTurnColor).isKingInCheck(square: position, board)
    }
    
    func setCoordinates (row: Int, column: Int) -> Coordinates {
        return Coordinates(row: row, column: column)
    }

    
    func setPlayerColor(color:ChessColor){
        model.playerIsColor = color
    }
    
    
    
    func enemyStandsOnSquare(_ position:Coordinates) -> Bool {
        return board[position.row][position.column] != nil
    }
    
    
    func handleMove(fromPosition: Coordinates, toPosition: Coordinates) -> Void {
        
        
        if moveIsValid(fromPosition: fromPosition, toPosition: toPosition) {
            print("move is valid")
            let selectedPiece = getChessPiece(fromPosition, board)
            switch selectedPiece.chessPiece {
            case .rook, .king:
                rookOrKingMoved(from: fromPosition, to: toPosition, chessPiece: selectedPiece.chessPiece)
            case .pawn:
                pawnWillMove(fromSquare: fromPosition, toSquare:  toPosition)
            default:
                pawnMadeTwoMovesSquare = nil
            }
            
            
            if let piece = board[toPosition.row][toPosition.column] {
                capturePiece(piece)
            }
            movePiece(from: fromPosition, to: toPosition)
            
            if selectedPiece.chessPiece == .pawn {
                pawnMoved(toSquare: toPosition)
            }
            
            
            
            model.currentTurnColor = model.currentTurnColor == .white ? .black : .white
            
            handleGameStatus(board)
            
            
            
        }
    }
    
    func rookOrKingMoved(from: Coordinates, to: Coordinates, chessPiece: ChessPiece) -> Void {
        
        
        switch (from) {
        case Coordinates(row: 0,column: 0):
            model.a8blackRookHasMoved = true
        case Coordinates(row: 0, column: 7):
            model.h8blackRookHasMoved = true
        case Coordinates(row: 7, column: 0):
            model.a1whiteRookHasMoved = true
        case Coordinates(row: 7, column: 7):
            model.h1whiteRookHasMoved = true
        case defaultBlackKingPos:
            model.blackKingHasMoved = true
        case defaultWhiteKingPos:
            model.whiteKingHasMoved = true
        default:
            break
        }
        
        // Check if the king has moved two squares horizontally
        if chessPiece == .king && abs(from.column - to.column) == 2 {
            let rookFrom: Coordinates
            let rookTo: Coordinates
            
            if to.column > from.column { // Kingside castling
                rookFrom = Coordinates(row: from.row, column: 7)
                rookTo = Coordinates(row: to.row, column: to.column - 1)
            } else { // Queenside castling
                rookFrom = Coordinates(row: from.row, column: 0)
                rookTo = Coordinates(row: to.row, column: to.column + 1)
            }
            
            movePiece(from: rookFrom, to: rookTo)
        }
    }
    
    func movePiece(from:Coordinates, to:Coordinates) -> Void {
        model.board[to.row][to.column] = board[from.row][from.column]
        model.board[from.row][from.column] = nil
        currentTurnColor = (currentTurnColor == .white) ? .black : .white
    }
    func hypotheticalMove(from: Coordinates, to:Coordinates) -> BoardClass {
        var board = model.board
        board[to.row][to.column] = board[from.row][from.column]
        board[from.row][from.column] = nil
        return board
    }
    
    func capturePiece(_ piece:Piece) -> Void {
        if piece.chessColor == .white  {
            model.whiteBeatenPieces.append( piece)
        } else {
            model.blackBeatenPieces.append(piece)
        }
        
        print(" Count of the beaten pieces white  \(model.whiteBeatenPieces.count)")
        print (" Count of the black beaten pieces black \(model.blackBeatenPieces.count)")
        return
    }
    
    func pawnWillMove(fromSquare:Coordinates, toSquare:Coordinates ) -> Void {
        
        if fromSquare.column != toSquare.column && board[toSquare.row][toSquare.column] == nil {
            captureEnPasant(square: pawnMadeTwoMovesSquare!)
        }
        pawnMadeTwoMovesSquare = nil
        
        /// pawn moved two squares
        if fromSquare.row == 1 && toSquare.row == 3 || fromSquare.row == 6 && toSquare.row == 4 {
            pawnMadeTwoMovesSquare = toSquare
        }
        
    }
    
    func pawnMoved(toSquare:Coordinates) -> Void {
        if toSquare.row == 0 || toSquare.row == 7  {
            promotePawn(square: toSquare, board)
        }
    }
    
    func captureEnPasant(square:Coordinates) -> Void {
        guard  let piece = board[square.row][square.column] else {return}
        
        
        model.board[square.row][square.column] = nil
        capturePiece(piece)
    }
    
    
    func moveIsValid(fromPosition:Coordinates, toPosition:Coordinates) -> Bool {
        return getValidMoves(position: fromPosition).contains(where: {$0.column == toPosition.column && $0.row == toPosition.row})
        
    }
    
    
    
    func getValidMoves(position:Coordinates) -> [Coordinates] {
        
        
        
        
        
        //TODO: a piece could avoid a check
        /* if isKingInCheck(square: findKing(currentTurnColor, board), board) && piece.chessPiece != .king {
         return []
         }*/
        //    let typeOfPiece = piece.chessPiece
        //var validMoves: [Coordinates] = getValidMovesForEachTypeOfPieces[typeOfPiece]!(position, board)
        typealias MoveFunction = (Coordinates) -> [Coordinates]
     
        
        let piece = getChessPiece(position, board)
        let ruleForThePiece = Rule.getRuleByChessPiece(model: model, color: piece.chessColor, chessPiece: piece.chessPiece)
        
        let validMoves: [Coordinates] = ruleForThePiece.validMoves(position)
        let movesThatAreInCheck = getMovesThatAreInCheck(from: position, moves: validMoves, board)
        
        return validMoves.filter { !movesThatAreInCheck.contains($0) }
    }
    
    func getMovesThatAreInCheck(from: Coordinates, moves: [Coordinates], _ board: BoardClass) -> [Coordinates] {
        let kingRule = KingRule(model: model, color: model.currentTurnColor)
        return moves.filter {
            let hypotheticalBoard =  kingRule.hypotheticalMove(from: from, to: $0)
            return kingRule.isKingInCheck(square: findKing(currentTurnColor, hypotheticalBoard), hypotheticalBoard)
        }
    }
    
 
    
    func promotePawn(square:Coordinates, _ board: BoardClass) -> Void {
        // let piece =  Piece(chessPiece: .queen, chessColor: getColorsFromCoords(square, board))
        //model.board[square.row][square.column] = piece
        model.pawnPromotes = Coordinates(row: square.row, column: square.column)
    }
    
    func promoteSelectedPawn(chosenPiece: ChessPiece){
        if let pawnPromotes = pawnPromotes {
            let piece =  Piece(chessPiece: chosenPiece, chessColor: getColorsFromCoords(pawnPromotes, board))
            model.board[pawnPromotes.row][pawnPromotes.column] = piece
            model.pawnPromotes = nil
        }
    }
    
    /// validates that coordinates are on the board and the square there is not a piece with the same color
    func isValidCoordinate(cord: Coordinates, color: ChessColor, _ board: BoardClass) -> Bool {
        return cord.row >= 0 && cord.row < 8 && cord.column >= 0 && cord.column < 8 && color != board[cord.row][cord.column]?.chessColor
    }
    
    func getColorsFromCoords(_ coords:Coordinates,_ board: BoardClass) -> ChessColor {
        board[coords.row][coords.column]!.chessColor
    }
    
    func getChessPiece(_ square: Coordinates, _ board: BoardClass) -> Piece {
        board[square.row][square.column]!
    }
    
    func  checkIfPieceOnTheGivenCoordinatesIsValid(_ square: Coordinates) -> Bool {
        let piece = board[square.row][square.column]
        return piece != nil && piece!.chessColor == model.currentTurnColor
    }
    
    
 
    
    func pieceIsOnSquares(squares: [Coordinates], piece: Piece, _ board: BoardClass) -> Bool {
        return squares.contains { board[$0.row][$0.column] == piece }
    }
    
    
    func findKing(_ color: ChessColor, _ board: BoardClass) -> Coordinates {
        findPiece(pieceToFind: Piece(chessPiece: .king, chessColor: color), board)!
    }
    
    func findPiece(pieceToFind: Piece, _ board: BoardClass) -> Coordinates? {
        for (row, rowPieces) in board.enumerated() {
            if let column = rowPieces.firstIndex(where: { $0 == pieceToFind }) {
                return Coordinates(row: row, column: column)
            }
        }
        return nil
    }
    
    
    
    func handleGameStatus( _ board: BoardClass) -> Void  {
        let kingRule = KingRule(model: model, color: model.currentTurnColor)
        if !isThereAValidMove(chessColor: model.currentTurnColor, board) {
            if kingRule.isKingInCheck(square: findKing(currentTurnColor, board), board) {
                print(currentTurnColor.rawValue + " is Checkmate")
                model.isCheckMate = currentTurnColor
            }else {
                model.isDraw = true
                print("it ist Draw")
            }
        }
    }
    
    
    
    func isThereAValidMove(chessColor: ChessColor, _ board: BoardClass) -> Bool {
        !getAllValidMoves(chessColor: chessColor, board).isEmpty
    }
    
    
    func getAllValidMoves(chessColor: ChessColor, _ board: BoardClass) -> [Coordinates] {
        var validSquares: [Coordinates] = []
        
        
        for (row,rowPieces) in board.enumerated() {
            for (col,pieces) in rowPieces.enumerated() {
                if pieces?.chessColor == chessColor {
                    validSquares += Rule.getRuleByChessPiece(model: model, color: model.currentTurnColor, chessPiece: pieces!.chessPiece).validMoves(Coordinates(row: row, column: col))
                }
            }
        }
        
        return validSquares
        
    }
    
    func restartGame() -> Void {
        model = Model()
        currentTurnColor = .white
        pawnMadeTwoMovesSquare = nil
        model.initialGameState = true
    }
    
    func startGame() -> Void {
        model.initialGameState = false
    }
    
    
    
    
    
    
}
/**
 
 */
