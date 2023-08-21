//
//  UIStackView+Extensions.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 18.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

extension UIStackView {
    
    public func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { result, subview -> [UIView] in
            self.removeArrangedSubview(subview)
            
            return result + [subview]
        }
        
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach{
            $0.removeFromSuperview()
        }
    }
}
