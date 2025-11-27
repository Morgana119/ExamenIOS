//
//  NetworkAPIService.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation
import Alamofire

//class NetworkAPIService {
//    static let shared = NetworkAPIService()
//
//    func getSudoku(
//        url: URL,
//        pattern: SudokuBoardPattern,
//        difficulty: SudokuDifficulty
//    ) async -> SudokuResponse? {
//
//        let parameters: Parameters = [
//            "width": pattern.boxSize,
//            "height": pattern.boxSize,
//            "difficulty": difficulty.rawValue
//        ]
//
//        let headers: HTTPHeaders = [
//            "X-Api-Key": "VrEQHTjqfH5nezjEPzK4RQ==FaXmetnIuGHva1fF"
//        ]
//
//        print("API con params:", parameters)
//
//        let taskRequest = AF.request(url, method: .get, parameters: parameters, headers: headers)
//            .validate()
//
//        let response = await taskRequest.serializingData().response
//
//        switch response.result {
//        case .success(let data):
//            do {
//                return try JSONDecoder().decode(SudokuResponse.self, from: data)
//            } catch {
//                return nil
//            }
//        case .failure(let error):
//            return nil
//        }
//    }
//}

// SOLUCIÓN PARA LOS +10 PUNTOS
class NetworkAPIService {
    static let shared = NetworkAPIService()

    func getSudoku(
        url: URL,
        pattern: SudokuBoardPattern,
        difficulty: SudokuDifficulty
    ) async -> SudokuResponse? {
        
        let parameters: Parameters = [
            "width": pattern.boxSize,
            "height": pattern.boxSize,
            "difficulty": difficulty.rawValue
        ]
        
        let headers: HTTPHeaders = [
            "X-Api-Key": "VrEQHTjqfH5nezjEPzK4RQ==FaXmetnIuGHva1fF"
        ]
        
        let taskRequest = AF.request(
            url,
            method: .get,
            parameters: parameters,
            headers: headers
        )
        .validate()
        
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            do {
                return try JSONDecoder().decode(SudokuResponse.self, from: data)
            } catch {
                return nil
            }
        case .failure(let error):
            return nil
        }
    }

    func solveSudoku(
        url: URL,
        pattern: SudokuBoardPattern,
        puzzle: [[Int]]
    ) async -> SudokuSolveResponse? {
        
        let puzzleString: String
        if let data = try? JSONSerialization.data(withJSONObject: puzzle, options: []),
           let str = String(data: data, encoding: .utf8) {
            puzzleString = str
        } else {
            puzzleString = "[]"
        }
        
        let parameters: Parameters = [
            "puzzle": puzzleString,
            "width": pattern.boxSize,
            "height": pattern.boxSize
        ]
        
        let headers: HTTPHeaders = [
            "X-Api-Key": "VrEQHTjqfH5nezjEPzK4RQ==FaXmetnIuGHva1fF"
        ]
        
        print("solveSudoku params:", parameters)
        
        let taskRequest = AF.request(
            url,
            method: .get,
            parameters: parameters,
            headers: headers
        )
        .validate()
        
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(SudokuSolveResponse.self, from: data)
                return decoded
            } catch {
                return nil
            }
        case .failure(let error):
            return nil
        }
    }
}
