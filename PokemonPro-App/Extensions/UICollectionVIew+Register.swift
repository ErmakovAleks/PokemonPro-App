//
//  UICollectionVIew+Register.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 14.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

extension UICollectionView {
    
    func register(cell: String) {
        let nib = UINib(nibName: cell, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cell)
    }
    
    func register(cellClass: AnyClass) {
        self.register(cell: String(describing: cellClass))
    }
}
