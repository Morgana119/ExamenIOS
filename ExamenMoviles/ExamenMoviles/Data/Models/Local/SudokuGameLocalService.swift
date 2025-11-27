//
//  SudokuGameLocalService.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation

class SudokuGameLocalService {
    static let shared = SudokuGameLocalService()
    private let gameKey = "sudokuSavedGame"
    
    func saveGame(_ state: SudokuGameState) {
        do {
            let data = try JSONEncoder().encode(state)
            UserDefaults.standard.set(data, forKey: gameKey)
        } catch {
        }
    }

    func loadGame() -> SudokuGameState? {
        guard let data = UserDefaults.standard.data(forKey: gameKey) else { return nil }
        do {
            return try JSONDecoder().decode(SudokuGameState.self, from: data)
        } catch {
            return nil
        }
    }
    
    func hasSavedGame() -> Bool {
        UserDefaults.standard.data(forKey: gameKey) != nil
    }
    
    func clearGame() {
        UserDefaults.standard.removeObject(forKey: gameKey)
    }
}
