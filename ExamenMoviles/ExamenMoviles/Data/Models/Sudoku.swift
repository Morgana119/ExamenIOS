//
//  Sudoku.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation

struct SudokuResponse: Codable {
    let puzzle: [[Int?]]
    let solution: [[Int]]
}

enum SudokuDifficulty: String, CaseIterable, Codable {
    case easy
    case medium
    case hard
    
    var displayName: String {
        rawValue.capitalized
    }
}

enum SudokuBoardPattern: CaseIterable, Codable {
    case twoByTwo
    case threeByThree
    
    var boxSize: Int {
        switch self {
        case .twoByTwo: return 2
        case .threeByThree: return 3
        }
    }
    
    var boardSize: Int {
        boxSize * boxSize
    }
    
    var blockTitle: String {
        switch self {
        case .twoByTwo: return "2x2"
        case .threeByThree: return "3x3"
        }
    }
    
    var fullTitle: String {
        "\(blockTitle) (\(boardSize)x\(boardSize))"
    }
}

struct SudokuGameState: Codable {
    let pattern: SudokuBoardPattern
    let difficulty: SudokuDifficulty
    let initialBoard: [[Int?]]
    let currentBoard: [[Int?]]
    let solution: [[Int]]
}
