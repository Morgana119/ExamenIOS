//
//  SudokuGameViewModel.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation
import Combine

enum SudokuViewState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
    case success(String)
}

enum SudokuGameStartMode {
    case new(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty)
    case resume
}

@MainActor
class SudokuGameViewModel: ObservableObject {
    @Published var board: [[Int?]] = []
    @Published var initialBoard: [[Int?]] = []
    @Published var solution: [[Int]] = []
    
    @Published var pattern: SudokuBoardPattern = .twoByTwo
    @Published var difficulty: SudokuDifficulty = .easy
    
    @Published var selectedRow: Int? = nil
    @Published var selectedCol: Int? = nil
    
    @Published var viewState: SudokuViewState = .idle
    @Published var lastVerificationSuccess: Bool? = nil
    
    @Published var verificationSuccess: Bool? = nil
    @Published var verificationMessage: String = ""
    
    var boardDimension: Int {
        board.first?.count ?? 0
    }
    
    let sudokuRequirement: SudokuRequirementProtocol
    let gameRequirement: SudokuGameRequirementProtocol
    
    init(
        sudokuRequirement: SudokuRequirementProtocol = SudokuRequirement.shared,
        gameRequirement: SudokuGameRequirementProtocol = SudokuGameRequirement.shared
    ) {
        self.sudokuRequirement = sudokuRequirement
        self.gameRequirement = gameRequirement
    }
    
    func start(mode: SudokuGameStartMode) async {
        switch mode {
        case .new(let pattern, let difficulty):
            await loadNewGame(pattern: pattern, difficulty: difficulty)
        case .resume:
            loadSavedGame()
        }
    }
    
    func loadNewGame(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async {
        viewState = .loading
        self.pattern = pattern
        self.difficulty = difficulty
        
        guard let response = await sudokuRequirement.generateSudoku(pattern: pattern, difficulty: difficulty) else {
            viewState = .error("No se pudo generar un nuevo puzzle. Revisa tu conexión e inténtalo de nuevo.")
            return
        }
//        print("PUZZLE:")
//        for row in response.puzzle {
//            print(row)
//        }
//        print("\nSOLUTION:")
//        for row in response.solution {
//            print(row)
//        }
        
        self.initialBoard = response.puzzle
        self.board = response.puzzle
        self.solution = response.solution
        
        self.selectedRow = nil
        self.selectedCol = nil
        
        saveCurrentGame()
        viewState = .loaded
    }
    
    func loadSavedGame() {
        viewState = .loading
        
        guard let state = gameRequirement.loadGame() else {
            viewState = .error("No se encontró una partida guardada.")
            return
        }
        
        self.pattern = state.pattern
        self.difficulty = state.difficulty
        self.initialBoard = state.initialBoard
        self.board = state.currentBoard
        self.solution = state.solution
        self.selectedRow = nil
        self.selectedCol = nil
        
        viewState = .loaded
    }
    
    func saveCurrentGame() {
        guard !initialBoard.isEmpty, !solution.isEmpty else { return }
        
        let state = SudokuGameState(
            pattern: pattern,
            difficulty: difficulty,
            initialBoard: initialBoard,
            currentBoard: board,
            solution: solution
        )
        
        gameRequirement.saveGame(state)
    }
    
    func selectCell(row: Int, col: Int) {
        guard initialBoard.indices.contains(row),
              initialBoard[row].indices.contains(col) else { return }
        
        if initialBoard[row][col] == nil {
            selectedRow = row
            selectedCol = col
        }
    }
    
    func enterNumber(_ value: Int) {
        guard let row = selectedRow,
              let col = selectedCol else { return }
        
        guard initialBoard[row][col] == nil else { return }
        
        if value == 0 {
            board[row][col] = nil
        } else {
            board[row][col] = value
        }
        
        saveCurrentGame()
    }
    
    func resetPuzzle() {
        board = initialBoard
        selectedRow = nil
        selectedCol = nil
        saveCurrentGame()
    }
    
    func verifySolution() {
        guard !board.isEmpty, !solution.isEmpty else { return }
        
        for r in 0..<board.count {
            for c in 0..<board[r].count {
                guard let value = board[r][c] else {
                    verificationSuccess = false
                    verificationMessage = "La solución está incompleta. Hay celdas vacías."
                    return
                }
                if solution.indices.contains(r),
                   solution[r].indices.contains(c),
                   solution[r][c] != value {
                    verificationSuccess = false
                    verificationMessage = "Hay uno o más números incorrectos. Puedes corregirlos y seguir jugando."
                    return
                }
            }
        }
        
        verificationSuccess = true
        verificationMessage = "¡Felicidades! La solución es correcta"
        saveCurrentGame()
    }
}


