//
//  URLContainable.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 26.07.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

protocol URLContainable {
    
    associatedtype DecodableType: Decodable
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get set }
    var body: [String: Any]? { get set }
}

extension URLContainable {
    
    var scheme: String {
        "https"
    }
    
    var host: String {
        "pokeapi.glitch.me"
    }
    
    var method: HTTPMethod {
        .get
    }
}
