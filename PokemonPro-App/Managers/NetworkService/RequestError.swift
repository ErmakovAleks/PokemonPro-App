//
//  RequestError.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 27.07.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

enum RequestError: LocalizedError {
    
    case decode
    case failure(Error)
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .decode:
            return "<!> Decode error"
        case .invalidURL:
            return "<!> URL is incorrect"
        case .noResponse:
            return "<!> There is no response from server"
        case .unauthorized:
            return "<!> Session expired"
        case .unexpectedStatusCode:
            return "<!> Unexpected status code"
        case .unknown:
            return "<!> Unknown error"
        case  .failure(let error):
            return error.localizedDescription
        }
    }
}
