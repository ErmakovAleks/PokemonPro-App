//
//  UIColor+Extensions.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 01.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

extension UIColor {
    
    static let gold = UIColor(red: 255/255, green: 215/255, blue: 7/255, alpha: 1.0)
    static let darkGold = UIColor(red: 235/255, green: 185/255, blue: 7/255, alpha: 1.0)
    static let wildSand = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    static let abbey = UIColor(red: 73/255, green: 79/255, blue: 84/255, alpha: 1.0)
    static let heather = UIColor(red: 186/255, green: 196/255, blue: 206/255, alpha: 1.0)
    static let sand = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1.0)
    
    static let fire = UIColor(red: 255/255, green: 233/255, blue: 233/255, alpha: 1.0)
    static let water = UIColor(red: 219/255, green: 227/255, blue: 255/255, alpha: 1.0)
    static let ice = UIColor(red: 211/255, green: 245/255, blue: 255/255, alpha: 1.0)
    static let electric = UIColor(red: 254/255, green: 249/255, blue: 204/255, alpha: 1.0)
    static let bug = UIColor(red: 230/255, green: 255/255, blue: 178/255, alpha: 1.0)
    static let steel = UIColor(red: 182/255, green: 216/255, blue: 233/255, alpha: 1.0)
    static let fairy = UIColor(red: 255/255, green: 214/255, blue: 252/255, alpha: 1.0)
    static let grass = UIColor(red: 217/255, green: 255/255, blue: 214/255, alpha: 1.0)
    static let ground = UIColor(red: 255/255, green: 214/255, blue: 193/255, alpha: 1.0)
    static let flying = UIColor(red: 223/255, green: 233/255, blue: 255/255, alpha: 1.0)
    static let dragon = UIColor(red: 176/255, green: 218/255, blue: 255/255, alpha: 1.0)
    static let fighting = UIColor(red: 255/255, green: 193/255, blue: 211/255, alpha: 1.0)
    static let dark = UIColor(red: 215/255, green: 205/255, blue: 234/255, alpha: 1.0)
    static let poison = UIColor(red: 189/255, green: 255/255, blue: 235/255, alpha: 1.0)
    static let psychic = UIColor(red: 254/255, green: 210/255, blue: 213/255, alpha: 1.0)
    static let normal = UIColor(red: 216/255, green: 225/255, blue: 234/255, alpha: 1.0)
    static let rock = UIColor(red: 223/255, green: 216/255, blue: 197/255, alpha: 1.0)
    static let ghost = UIColor(red: 206/255, green: 219/255, blue: 255/255, alpha: 1.0)
    
    static let fireFont = UIColor(red: 255/255, green: 79/255, blue: 55/255, alpha: 1.0)
    static let waterFont = UIColor(red: 105/255, green: 138/255, blue: 255/255, alpha: 1.0)
    static let iceFont = UIColor(red: 0/255, green: 194/255, blue: 255/255, alpha: 1.0)
    static let electricFont = UIColor(red: 236/255, green: 184/255, blue: 0/255, alpha: 1.0)
    static let bugFont = UIColor(red: 144/255, green: 193/255, blue: 44/255, alpha: 1.0)
    static let steelFont = UIColor(red: 90/255, green: 142/255, blue: 161/255, alpha: 1.0)
    static let fairyFont = UIColor(red: 236/255, green: 143/255, blue: 230/255, alpha: 1.0)
    static let grassFont = UIColor(red: 99/255, green: 187/255, blue: 91/255, alpha: 1.0)
    static let groundFont = UIColor(red: 186/255, green: 88/255, blue: 39/255, alpha: 1.0)
    static let flyingFont = UIColor(red: 146/255, green: 170/255, blue: 222/255, alpha: 1.0)
    static let dragonFont = UIColor(red: 9/255, green: 109/255, blue: 196/255, alpha: 1.0)
    static let fightingFont = UIColor(red: 206/255, green: 64/255, blue: 105/255, alpha: 1.0)
    static let darkFont = UIColor(red: 90/255, green: 83/255, blue: 102/255, alpha: 1.0)
    static let poisonFont = UIColor(red: 51/255, green: 159/255, blue: 140/255, alpha: 1.0)
    static let psychicFont = UIColor(red: 249/255, green: 113/255, blue: 118/255, alpha: 1.0)
    static let normalFont = UIColor(red: 144/255, green: 153/255, blue: 161/255, alpha: 1.0)
    static let rockFont = UIColor(red: 150/255, green: 134/255, blue: 90/255, alpha: 1.0)
    static let ghostFont = UIColor(red: 82/255, green: 105/255, blue: 172/255, alpha: 1.0)
}

extension UIColor {
    
    func normalizedColor(to value: CGFloat = 0.75) -> UIColor {
        let max = (self.cgColor.components?.dropLast())?.max() ?? 0.0
        let difference = 1.0 - max
        let normalizedColor = CGColor(
            red: (self.cgColor.components?[0] ?? 1.0) + difference * value,
            green: (self.cgColor.components?[1] ?? 1.0) + difference * value,
            blue: (self.cgColor.components?[2] ?? 1.0) + difference * value,
            alpha: self.cgColor.components?[3] ?? 1.0
        )
        
        return UIColor(cgColor: normalizedColor)
    }
}
