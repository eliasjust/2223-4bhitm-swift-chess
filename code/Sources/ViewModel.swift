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
    
    let databaseUri = Model.DATABASE

    
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
            
            let gameOverRule = Rule(model: model, maxReach: 7, directions: [], color: model.currentTurnColor)
            gameOverRule.handleGameStatus()
            
            
            
            
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
        let piece = getChessPiece(to, board)
        
        currentTurnColor = (currentTurnColor == .white) ? .black : .white
    }
    
    
    func capturePiece(_ piece:Piece) -> Void {
        if piece.chessColor == .white  {
            model.whiteBeatenPieces.append( piece)
        } else {
            model.blackBeatenPieces.append(piece)
        }
        
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
        
        
        
        
        
        typealias MoveFunction = (Coordinates) -> [Coordinates]
        
        let kingRule = KingRule(model: model, color: model.currentTurnColor)
        let piece = getChessPiece(position, board)
        let ruleForThePiece = Rule.getRuleByChessPiece(model: model, color: piece.chessColor, chessPiece: piece.chessPiece)
        
        let validMoves: [Coordinates] = ruleForThePiece.validMoves(position, board)
        let movesThatAreInCheck = kingRule.getMovesThatAreInCheck(from: position, moves: validMoves, board)
        
        return validMoves.filter { !movesThatAreInCheck.contains($0) }
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
    
    func findKing(_ color: Model.ChessColor) -> Coordinates {
        findPiece(pieceToFind: Model.Piece(chessPiece: .king, chessColor: color), board)!
    }
    
    func findPiece(pieceToFind: Model.Piece, _ board: Model.BoardClass) -> Coordinates? {
        for (row, rowPieces) in board.enumerated() {
            if let column = rowPieces.firstIndex(where: { $0 == pieceToFind }) {
                return Coordinates(row: row, column: column)
            }
        }
        return nil
    }
  
    
    func restartGame() -> Void {
        model = Model()
        currentTurnColor = .white
        pawnMadeTwoMovesSquare = nil
        model.initialGameState = true
    }
    
    func startGame() -> Void {
        model.initialGameState = false
        self.fetchBoardState() {
            
        }
    }
    
    func fetchBoardState(completion: @escaping () -> Void) {
        let fetchQueue = DispatchQueue(label: "Fetch Board State")
        fetchQueue.async {
            if let data = ViewModel.loadBoardState(){
                DispatchQueue.main.async {
                    self.model.updateBoardFromJson(data: data)
                    completion()
                }
            }
        }
    }

    static func loadBoardState() -> Data? {
        var data: Data?
        if let url = URL(string: Model.DATABASE) {
            data = try? Data(contentsOf: url)
        }
        return data
    }

    
    
}
/**
 
 */
