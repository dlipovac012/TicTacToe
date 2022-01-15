//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Dalibor Lipovac on 15.1.22..
//

import SwiftUI


enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isFieldOccupeid(forIndex: position) { return }
        
        moves[position] = Move(player: .human, boardIndex: position)
        isBoardDisabled = true
        
        // check for win condition or draw
        if checkWinCondition(for: .human) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw() {
            alertItem = AlertContext.draw
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computersPosition = self.determineComputerMovePosition()
            
            moves[computersPosition] = Move(player: .computer, boardIndex: computersPosition)
            
            isBoardDisabled = false
            
            if checkWinCondition(for: .computer) {
                alertItem = AlertContext.computerWin
                return
            }
        }
    }
    
    func isFieldOccupeid(forIndex index: Int) -> Bool {
        return self.moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition() -> Int {
        let MIDDLE_FIELD = 4
        
        // if there is a possible win condition, take it
        let winPatterns: Set<Set<Int>> = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]
        
        let computerMoves = Set(moves.compactMap { $0 }.filter { $0.player == .computer }.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerMoves)
            
            if winPositions.count == 1 {
                let isAvailable = !isFieldOccupeid(forIndex: winPositions.first!)
                
                if isAvailable { return winPositions.first! }
            }
        }
        
        // if you cant win, try to block other player
        let humanMoves = Set(moves.compactMap { $0 }.filter { $0.player == .human }.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanMoves)
            
            if winPositions.count == 1 {
                let isAvailable = !isFieldOccupeid(forIndex: winPositions.first!)
                
                if isAvailable { return winPositions.first! }
            }
        }
        
        // if none of the above works, take middle if its available
        if !isFieldOccupeid(forIndex: MIDDLE_FIELD) {
            return MIDDLE_FIELD
        }
        
        
        // if none of the above works, pick a random field
        var movePosition = Int.random(in: 0..<9)
        
        while isFieldOccupeid(forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player) -> Bool {
        let winPatterns: Set<Set<Int>> = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]
        
        let playerMoves = Set(moves.compactMap { $0 }.filter { $0.player == player }.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerMoves) {
            return true
        }
        return false
    }
    
    func checkForDraw() -> Bool {
        return moves.compactMap { $0 }.count == 9 ? true : false
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isBoardDisabled = false
    }
}
