//
//  PokemonDetail.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 08.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

struct PokemonDetailParams: URLContainable {
    
    typealias DecodableType = [PokemonDetail]
    
    var path: String = "/v1/pokemon/"
    var header: [String : String]?
    var body: [String : Any]?
    
    init(name: String) {
        self.path += name
    }
}

struct PokemonDetail: Codable {
    
    let number: String
    let name: String
    let types: [PokeType]
    //let types: [String]
    let abilities: Abilities
    let height: String
    let weight: String
    let family: Family
    let sprite: URL
    let description: String
}

// MARK: -
// MARK: - Abilities

struct Abilities: Codable {
    
    let normal: [String]
    let hidden: [String]
}

// MARK: -
// MARK: - Family

struct Family: Codable {
    
    let evolutionLine: [String]
}

// MARK: -
// MARK: Types

enum PokeType: String, Codable {
    
    case fire = "Fire"
    case water = "Water"
    case grass = "Grass"
    case electric = "Electric"
    case flying = "Flying"
    case poison = "Poison"
    case bug = "Bug"
    case ground = "Ground"
    case fairy = "Fairy"
    case normal = "Normal"
    case steel = "Steel"
    case fighting = "Fighting"
    case rock = "Rock"
    case ghost = "Ghost"
    case psychic = "Psychic"
    case ice = "Ice"
    case dragon = "Dragon"
    case dark = "Dark"
    
    var color: UIColor {
        switch self {
        case .fire:
            return UIColor.fire
        case .water:
            return UIColor.water
        case .grass:
            return UIColor.grass
        case .electric:
            return UIColor.electric
        case .flying:
            return UIColor.flying
        case .poison:
            return UIColor.poison
        case .bug:
            return UIColor.bug
        case .ground:
            return UIColor.ground
        case .fairy:
            return UIColor.fairy
        case .normal:
            return UIColor.normal
        case .steel:
            return UIColor.steel
        case .fighting:
            return UIColor.fighting
        case .rock:
            return UIColor.rock
        case .ghost:
            return UIColor.ghost
        case .psychic:
            return UIColor.psychic
        case .ice:
            return UIColor.ice
        case .dragon:
            return UIColor.dragon
        case .dark:
            return UIColor.dark
        }
    }
    
    var fontColor: UIColor {
        switch self {
        case .fire:
            return UIColor.fireFont
        case .water:
            return UIColor.waterFont
        case .grass:
            return UIColor.grassFont
        case .electric:
            return UIColor.electricFont
        case .flying:
            return UIColor.flyingFont
        case .poison:
            return UIColor.poisonFont
        case .bug:
            return UIColor.bugFont
        case .ground:
            return UIColor.groundFont
        case .fairy:
            return UIColor.fairyFont
        case .normal:
            return UIColor.normalFont
        case .steel:
            return UIColor.steelFont
        case .fighting:
            return UIColor.fightingFont
        case .rock:
            return UIColor.rockFont
        case .ghost:
            return UIColor.ghostFont
        case .psychic:
            return UIColor.psychicFont
        case .ice:
            return UIColor.iceFont
        case .dragon:
            return UIColor.dragonFont
        case .dark:
            return UIColor.darkFont
        }
    }
    
    var image: UIImage? {
        switch self {
        case .fire:
            return UIImage(named: "fire")
        case .water:
            return UIImage(named: "water")
        case .grass:
            return UIImage(named: "grass")
        case .electric:
            return UIImage(named: "electric")
        case .flying:
            return UIImage(named: "flying")
        case .poison:
            return UIImage(named: "poison")
        case .bug:
            return UIImage(named: "bug")
        case .ground:
            return UIImage(named: "ground")
        case .fairy:
            return UIImage(named: "fairy")
        case .normal:
            return UIImage(named: "normal")
        case .steel:
            return UIImage(named: "steel")
        case .fighting:
            return UIImage(named: "fighting")
        case .rock:
            return UIImage(named: "rock")
        case .ghost:
            return UIImage(named: "ghost")
        case .psychic:
            return UIImage(named: "psychic")
        case .ice:
            return UIImage(named: "icy")
        case .dragon:
            return UIImage(named: "dragon")
        case .dark:
            return UIImage(named: "dark")
        }
    }
}

// MARK: -
// MARK: PokemonCollectionItem

struct PokemonCollectionItem {
    
    let number: Int
    let name: String
    let types: [PokeType]
    let abilities: [String]
    let height: Int
    let weight: Int
    let evolutionLine: [String]
    let image: UIImage
    let description: String
    
    static func convert(pokemonDetail: PokemonDetail, image: UIImage) -> Self {
        return PokemonCollectionItem(
            number: Int(pokemonDetail.number) ?? 0,
            name: pokemonDetail.name,
            types: pokemonDetail.types,
            abilities: pokemonDetail.abilities.normal + pokemonDetail.abilities.hidden,
            height: Self.convert(height: pokemonDetail.height),
            weight: Self.convert(weight: pokemonDetail.weight),
            evolutionLine: pokemonDetail.family.evolutionLine,
            image: image,
            description: pokemonDetail.description
        )
    }
    
    static func startItem() -> Self {
        return PokemonCollectionItem(
            number: 1,
            name: "What pokemon?",
            types: [.electric, .fire],
            abilities: [],
            height: 0,
            weight: 0,
            evolutionLine: [],
            image: UIImage(named: "whatPokemon") ?? UIImage(),
            description: ""
        )
    }
    
    private static func convert(height: String) -> Int {
        var hgt = height.replacingOccurrences(of: "'", with: ".")
        hgt.removeAll { $0 == "\\" }
        
        return Int(((Double(hgt) ?? 0.0) * 2.54).rounded())
    }
    
    private static func convert(weight: String) -> Int {
        let wht = weight.split(separator: " ")
        
        return Int(((Double(wht.first ?? "0.0") ?? 0.0) * 0.453).rounded())
    }
}
