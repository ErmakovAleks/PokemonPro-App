//
//  Fonts.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 01.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

enum AppFonts: String {
    
    case paytone = "PaytoneOne-Regular"
    case plusJacartaSans = "PlusJakartaSans-VariableFont_wght"
    case plusJacartaSansItalic = "PlusJakartaSans-Italic-VariableFont_wght"
}

extension UIFont {
    
    static func paytoneOneRegular(size: CGFloat) -> UIFont {
        UIFont(name: AppFonts.paytone.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func plusJacartaSans(size: CGFloat) -> UIFont {
        UIFont(name: AppFonts.plusJacartaSans.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func plusJacartaSansItalic(size: CGFloat) -> UIFont {
        UIFont(name: AppFonts.plusJacartaSansItalic.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
