//
//  NetworkServiceContainable.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 26.07.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

protocol NetworkServiceContainable {

    associatedtype Service: NetworkSessionProcessable
}

extension NetworkServiceContainable {

    typealias Service = NetworkService
}
