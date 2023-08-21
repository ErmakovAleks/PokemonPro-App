//
//  ItemHeightDelegateContainable.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 18.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

protocol ItemHeightDelegateContainable: UICollectionViewLayout {
    
    var delegate: MosaicLayoutDelegate? { get set }
}
