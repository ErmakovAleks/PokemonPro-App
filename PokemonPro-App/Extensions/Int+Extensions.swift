//
//  Int+Extensions.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 18.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

extension Int {
    
    func toBondFormat() -> String {
        "#\(String(format: "%03d", self))"
    }
}
