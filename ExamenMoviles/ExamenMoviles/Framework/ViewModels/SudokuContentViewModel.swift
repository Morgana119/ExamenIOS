//
//  SudokuContentViewModel.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation
import Combine

class SudokuContentViewModel: ObservableObject {
    @Published var selectedPattern: SudokuBoardPattern = .twoByTwo
    @Published var selectedDifficulty: SudokuDifficulty = .easy
    @Published var hasSavedGame: Bool = false
    
    let gameRequirement: SudokuGameRequirementProtocol
    
    init(gameRequirement: SudokuGameRequirementProtocol = SudokuGameRequirement.shared) {
        self.gameRequirement = gameRequirement
        self.hasSavedGame = gameRequirement.hasSavedGame()
    }
    
    func refreshSavedGameStatus() {
        hasSavedGame = gameRequirement.hasSavedGame()
    }
}
