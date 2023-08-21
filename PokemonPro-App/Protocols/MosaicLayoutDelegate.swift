//
//  MosaicLayoutDelegate.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 16.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

protocol MosaicLayoutDelegate: AnyObject {
    
    func collectionView(
        _ collectionView: UICollectionView,
        heightForItemAtIndexPath indexPath: IndexPath,
        itemWidth: CGFloat
    ) -> CGFloat
}
