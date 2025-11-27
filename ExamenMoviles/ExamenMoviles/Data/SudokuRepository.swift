//
//  SudokuRepository.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation

//struct Api {
//    static let base = "https://api.api-ninjas.com/v1/"
//
//    struct routes {
//        static let generate = "sudokugenerate"
//    }
//}
//
//protocol SudokuAPIProtocol {
//    func generateSudoku(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async -> SudokuResponse?
//}
//
//class SudokuRepository: SudokuAPIProtocol {
//    static let shared = SudokuRepository()
//    let nservice: NetworkAPIService
//
//    init(nservice: NetworkAPIService = NetworkAPIService.shared) {
//        self.nservice = nservice
//    }
//
//    func generateSudoku(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async -> SudokuResponse? {
//        guard let url = URL(string: "\(Api.base)\(Api.routes.generate)") else {
//            return nil
//        }
//        return await nservice.getSudoku(url: url, pattern: pattern, difficulty: difficulty)
//    }
//}

// SOLUCIÓN PARA LOS +10 PUNTOS
struct Api {
    static let base = "https://api.api-ninjas.com/v1/"
    
    struct routes {
        static let generate = "sudokugenerate"
        static let solve    = "sudokusolve"
    }
}

protocol SudokuAPIProtocol {
    func generateSudoku(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async -> SudokuResponse?
    func solveSudoku(pattern: SudokuBoardPattern, puzzle: [[Int]]) async -> SudokuSolveResponse?
}

class SudokuRepository: SudokuAPIProtocol {
    static let shared = SudokuRepository()
    let nservice: NetworkAPIService

    init(nservice: NetworkAPIService = NetworkAPIService.shared) {
        self.nservice = nservice
    }
    
    func generateSudoku(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async -> SudokuResponse? {
        guard let url = URL(string: "https://api.api-ninjas.com/v1/sudokugenerate") else { return nil }
        return await nservice.getSudoku(url: url, pattern: pattern, difficulty: difficulty)
    }
    
    func solveSudoku(pattern: SudokuBoardPattern, puzzle: [[Int]]) async -> SudokuSolveResponse? {
        guard let url = URL(string: "https://api.api-ninjas.com/v1/sudokusolve") else { return nil }
        return await nservice.solveSudoku(url: url, pattern: pattern, puzzle: puzzle)
    }
}
