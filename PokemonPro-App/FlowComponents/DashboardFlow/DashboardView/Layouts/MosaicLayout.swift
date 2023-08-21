//
//  MosaicLayout.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 16.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class MosaicLayout: UICollectionViewLayout, ItemHeightDelegateContainable {
    
    // MARK: -
    // MARK: Delegates

    weak var delegate: MosaicLayoutDelegate?
    
    // MARK: -
    // MARK: Variables

    private let numberOfColumns = 2
    private let cellPadding: CGFloat

    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
      guard let collectionView = collectionView else { return 0 }
      let insets = collectionView.contentInset
        
      return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        
      return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: -
    // MARK: Initializators
    
    init(cellPadding: CGFloat) {
        self.cellPadding = cellPadding / 2.0
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Functions
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        let columnWidth = (self.contentWidth - 23.0) / CGFloat(self.numberOfColumns)
        var xOffset = [CGFloat]()
        
        for column in 0..<self.numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth + 11.5)
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: self.numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let itemHeight = delegate?.collectionView(
                collectionView,
                heightForItemAtIndexPath: indexPath,
                itemWidth: columnWidth
            ) ?? 180
            
            let height = self.cellPadding * 2 + itemHeight
            let frame = CGRect(
                x: xOffset[column],
                y: yOffset[column],
                width: columnWidth,
                height: height
            )
            
            let insetFrame = frame.insetBy(dx: self.cellPadding, dy: self.cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            self.cache.append(attributes)
            self.contentHeight = max(self.contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column < (self.numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]?
    {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in self.cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes?
    {
        return cache[indexPath.item]
    }
}
