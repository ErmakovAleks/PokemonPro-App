//
//  UIImage+Extension.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 28.07.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

extension UIView {
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
