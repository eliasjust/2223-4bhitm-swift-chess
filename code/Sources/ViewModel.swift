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
    typealias PieceDto = Model.PieceDto
    typealias GameDTO = Model.GameDto


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
    
    var gameIsEnded = false;
    
    var pawnPromotes:Coordinates? {
        model.pawnPromotes
    }
    
    typealias BoardClass = [[Piece?]]
    
    var board: BoardClass {
        model.board
    }
    
    var currentTurnColor: ChessColor {
        model.currentTurnColor
    }
    
    
    ///needed for en passant
    var pawnMadeTwoMovesSquare: Coordinates? {
        model.pawnMadeTwoMovesSquare
    }
    
    
    func isKingInCheck(position: Coordinates) -> Bool {
        return  Rule(model: model, maxReach: 7, directions: [], color: model.currentTurnColor).isKingInCheck(square: position, board)
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
                model.pawnMadeTwoMovesSquare = nil
            }
            
            
            if let piece = board[toPosition.row][toPosition.column] {
                capturePiece(piece)
            }
            movePiece(from: fromPosition, to: toPosition)
            
            if selectedPiece.chessPiece == .pawn {
                pawnMoved(toSquare: toPosition)
            }
            
            
            
           // model.currentTurnColor = model.currentTurnColor == .white ? .black : .white
            
            let gameOverRule = Rule(model: model, maxReach: 7, directions: [], color: model.currentTurnColor)
          handleGameStatus()
       
        }
    }
    
    
    func handleGameStatus() -> Void  {
        let turnColor = model.currentTurnColor
        let rule = Rule(model: model, maxReach: 7, directions: [], color: model.currentTurnColor)
        let kingPosition = rule.findKing(turnColor, model.board)
        let areNoThereValidMoves = rule.getAllValidMoves(model: model, forColor: turnColor).isEmpty
        if areNoThereValidMoves {
            let rule = Rule(model: model, maxReach: 7, directions: [], color: turnColor)
            if rule.isKingInCheck(square:  kingPosition, model.board) {
                print("\(model.currentTurnColor) is Checkmate")
                print(turnColor)
                model.isCheckMate = turnColor
            }else {
                model.isDraw = true
                print("it ist Draw")
            }
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
        model.currentTurnColor = (currentTurnColor == .white) ? .black : .white
        sendBoard(board: board)
    }
    
    
    func capturePiece(_ piece:Piece) -> Void {
        if piece.chessColor == .white  {
            model.whiteBeatenPieces.append( piece)
        } else {
            model.blackBeatenPieces.append(piece)
        }
        
        return
    }
    
    func pawnWillMove(fromSquare: Coordinates, toSquare: Coordinates ) -> Void {
        if fromSquare.column != toSquare.column && board[toSquare.row][toSquare.column] == nil {
            captureEnPasant(square: pawnMadeTwoMovesSquare!)
        }
        
        model.pawnMadeTwoMovesSquare = nil
        /// pawn moved two squares
        if fromSquare.row == 1 && toSquare.row == 3 || fromSquare.row == 6 && toSquare.row == 4 {
            model.pawnMadeTwoMovesSquare = toSquare
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
    
    /**
     Verifies if a move from one position to another is valid.

     - Parameters:
       - fromPosition: The starting position.
       - toPosition: The desired ending position.
     - Returns: A boolean value indicating whether the move is valid (`true`) or not (`false`).
    */
    func moveIsValid(fromPosition:Coordinates, toPosition:Coordinates) -> Bool {
        return getAllValidMoves(position: fromPosition).contains(where: {$0.column == toPosition.column && $0.row == toPosition.row})
        
    }
    
    
    
    func getAllValidMoves(position:Coordinates) -> [Coordinates] {
        let rule = Rule(model: model, maxReach: 7, directions: [], color: currentTurnColor)
        
        return rule.getAllValidMovesForSquare(square: position)
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
            self.sendBoard(board: board)
        }
    }
    
    
    
    func getColorsFromCoords(_ coords:Coordinates, _ board: BoardClass) -> ChessColor {
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
        model.currentTurnColor = .white
        model.pawnMadeTwoMovesSquare = nil
        model.initialGameState = true
        self.sendBoard(board: board)
        self.fetchBoardState() {

        }
    }
    
    func startGame() -> Void {
        model.initialGameState = false
        startUpdatingBoard()
        
        self.sendBoard(board: board)
        self.fetchBoardState() {
        }
    }
    
    func fetchBoardState(completion: @escaping () -> Void) {
        let fetchQueue = DispatchQueue(label: "Fetch Board State")
        fetchQueue.async {
            if let data = ViewModel.loadBoardState(){
                DispatchQueue.main.async {
                    self.updateBoardFromJson(data: data)
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

    func updateBoardFromJson(data: Data) {

        if let databaseGame = try? JSONDecoder().decode(GameDTO.self, from: data){

            model.currentTurnColor = Model.ChessColor(rawValue: databaseGame.currentTurnColor) ?? .white
            let databaseBoard = databaseGame.board

            var finalBoard: BoardClass = Array(repeating: Array(repeating: nil, count: 8), count: 8)
            for (i, row) in databaseBoard.enumerated() {
                for (j, col) in row.enumerated() {
                    if let pieceString = col {
                        if let chessPiece = Model.ChessPiece(rawValue: pieceString.chessPiece),
                           let chessColor = Model.ChessColor(rawValue: pieceString.chessColor) {


                            let validPiece = Piece(chessPiece: chessPiece, chessColor: chessColor)
                            finalBoard[i][j] = validPiece
                        }else {
                            finalBoard[i][j] = nil
                        }
                    }

                }
            }
            model.board = finalBoard
        }
    }


    var timer: Timer?

    func startUpdatingBoard() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateBoard()
        }
    }

    func stopUpdatingBoard() {
        timer?.invalidate()
        timer = nil
    }

    func updateBoard() {
        self.fetchBoardState() {

        }
    }

    func sendBoard(board: BoardClass) -> Void {
        let boardDto = toBoardDto(board: board)
        let gameDto = GameDTO(currentTurnColor: model.currentTurnColor.rawValue, board: boardDto)

        guard let data = try? JSONEncoder().encode(gameDto) else {
            print("Failed to encode board")
            return
        }

        guard let url = URL(string: databaseUri) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending data: \(error)")
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Unexpected status code: \(response.statusCode)")
            } else {
                print("Data sent successfully")
            }
        }
        task.resume()
    }

    func toBoardDto(board: BoardClass) -> [[PieceDto?]] {
        var id = 0;
        return board.map { row in
            row.map { piece in
                id = id+1
                guard let piece = piece else {
                    return PieceDto(chessColor: "", chessPiece: "")                   }
                return PieceDto(chessColor: piece.chessColor.rawValue, chessPiece: piece.chessPiece.rawValue)
            }
        }
    }
    
    
    
}

