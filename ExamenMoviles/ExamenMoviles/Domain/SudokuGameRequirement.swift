//
//  SudokuGameRequirement.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation

protocol SudokuGameRequirementProtocol {
    func saveGame(_ state: SudokuGameState)
    func loadGame() -> SudokuGameState?
    func hasSavedGame() -> Bool
    func clearGame()
}

class SudokuGameRequirement: SudokuGameRequirementProtocol {
    static let shared = SudokuGameRequirement()
    let dataRepository: SudokuGameRepository
    
    init(dataRepository: SudokuGameRepository = SudokuGameRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func saveGame(_ state: SudokuGameState) {
        dataRepository.saveGame(state)
    }
    
    func loadGame() -> SudokuGameState? {
        dataRepository.loadGame()
    }
    
    func hasSavedGame() -> Bool {
        dataRepository.hasSavedGame()
    }
    
    func clearGame() {
        dataRepository.clearGame()
    }
}
