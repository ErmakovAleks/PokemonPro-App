//
//  BaseExperience.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 31.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation


struct BaseExperience: Decodable {
    
    let baseExperience: Int
    let moves: [Move]
    
    enum CodingKeys: String, CodingKey {
        
        case baseExperience = "base_experience"
        case moves
    }
}

struct Move: Codable {
    
    let move: Species
}

struct Species: Codable {
    
    let name: String
    let url: String
}
