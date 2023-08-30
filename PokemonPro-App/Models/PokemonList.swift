//
//  PokemonList.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 08.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

struct PokemonsParams: URLContainable {

    typealias DecodableType = PokemonList
    
    var host: String = "pokeapi.co"
    var path: String = "/api/v2/pokemon/"
    var header: [String : String]?
    var body: [String : Any]?
    
    init(limit: Int = 20, offset: Int = 0) {
        self.header =
        [
            "limit" : "\(limit)",
            "offset" : "\(offset)"
        ]
    }
}

struct PokemonList: Decodable {
    
    let count: Int?
    let next: URL?
    let previous: URL?
    let results: [Pokemon]?
}

struct Pokemon: Codable {
    
    public let name: String
    public let url: URL
}
