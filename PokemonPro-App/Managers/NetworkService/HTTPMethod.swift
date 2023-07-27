//
//  HTTPMethod.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 27.07.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

enum HTTPMethod: String {
    
    case delete = "DELETE"
    case `get`  = "GET"
    case patch  = "PATCH"
    case post   = "POST"
    case put    = "PUT"
}
