//
//  SudokuRequirement.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation

//protocol SudokuRequirementProtocol {
//    func generateSudoku(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async -> SudokuResponse?
//}
//
//class SudokuRequirement: SudokuRequirementProtocol {
//    static let shared = SudokuRequirement()
//    let dataRepository: SudokuRepository
//
//    init(dataRepository: SudokuRepository = SudokuRepository.shared) {
//        self.dataRepository = dataRepository
//    }
//
//    func generateSudoku(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async -> SudokuResponse? {
//        await dataRepository.generateSudoku(pattern: pattern, difficulty: difficulty)
//    }
//}

// SOLUCIÓN PARA LOS +10 PUNTOS
protocol SudokuRequirementProtocol {
    func generateSudoku(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async -> SudokuResponse?
    func solveSudoku(pattern: SudokuBoardPattern, puzzle: [[Int]]) async -> SudokuSolveResponse?
}

class SudokuRequirement: SudokuRequirementProtocol {
    static let shared = SudokuRequirement()
    let dataRepository: SudokuRepository

    init(dataRepository: SudokuRepository = SudokuRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func generateSudoku(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async -> SudokuResponse? {
        await dataRepository.generateSudoku(pattern: pattern, difficulty: difficulty)
    }
    
    func solveSudoku(pattern: SudokuBoardPattern, puzzle: [[Int]]) async -> SudokuSolveResponse? {
        await dataRepository.solveSudoku(pattern: pattern, puzzle: puzzle)
    }
}
