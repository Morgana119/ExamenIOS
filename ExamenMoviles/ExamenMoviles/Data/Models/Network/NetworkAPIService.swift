//
//  NetworkAPIService.swift
//  ExamenMoviles
//
//  Created by Fátima Figueroa on 27/11/25.
//

import Foundation
import Alamofire

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
        
        print("API con params:", parameters)
        
        let taskRequest = AF.request(url, method: .get, parameters: parameters, headers: headers)
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
}
