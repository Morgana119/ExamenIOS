//
//  SudokuRepository.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation

struct Api {
    static let base = "https://api.api-ninjas.com/v1/"
    
    struct routes {
        static let generate = "sudokugenerate"
    }
}

protocol SudokuAPIProtocol {
    func generateSudoku(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async -> SudokuResponse?
}

class SudokuRepository: SudokuAPIProtocol {
    static let shared = SudokuRepository()
    let nservice: NetworkAPIService
    
    init(nservice: NetworkAPIService = NetworkAPIService.shared) {
        self.nservice = nservice
    }
    
    func generateSudoku(pattern: SudokuBoardPattern, difficulty: SudokuDifficulty) async -> SudokuResponse? {
        guard let url = URL(string: "\(Api.base)\(Api.routes.generate)") else {
            return nil
        }
        return await nservice.getSudoku(url: url, pattern: pattern, difficulty: difficulty)
    }
}
