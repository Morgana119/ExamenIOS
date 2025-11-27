//
//  SudokuGameRepository.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation

protocol SudokuGameServiceProtocol {
    func saveGame(_ state: SudokuGameState)
    func loadGame() -> SudokuGameState?
    func hasSavedGame() -> Bool
    func clearGame()
}

class SudokuGameRepository: SudokuGameServiceProtocol {
    static let shared = SudokuGameRepository()
    var localService: SudokuGameLocalService
    
    init(localService: SudokuGameLocalService = SudokuGameLocalService.shared) {
        self.localService = localService
    }
    
    func saveGame(_ state: SudokuGameState) {
        localService.saveGame(state)
    }
    
    func loadGame() -> SudokuGameState? {
        localService.loadGame()
    }
    
    func hasSavedGame() -> Bool {
        localService.hasSavedGame()
    }
    
    func clearGame() {
        localService.clearGame()
    }
}
