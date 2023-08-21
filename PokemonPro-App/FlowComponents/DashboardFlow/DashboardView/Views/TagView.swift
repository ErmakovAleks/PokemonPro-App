//
//  TagView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 19.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import SnapKit

final class TagView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    private var mode: RepresentMode?
    private var type: PokeType?
    
    private let imageView = UIImageView()
    private let label = UILabel()
    
    // MARK: -
    // MARK: Overrided properties
    
    override var intrinsicContentSize: CGSize {
        let imageSize = imageView.intrinsicContentSize
        let labelSize = label.intrinsicContentSize
        let width: CGFloat
        let height: CGFloat
        
        switch mode {
        case .list:
            width = 4.0 + imageSize.width + 4.0 + labelSize.width + 8.0
            height = 3.5 + imageSize.height + 3.5
        case .mosaic:
            width = 2.0 + imageSize.width + 2.0
            height = 2.0 + imageSize.height + 2.0
        case .none:
            width = 0.0
            height = 0.0
        }
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: -
    // MARK: Initializators
    
    init(mode: RepresentMode, type: PokeType) {
        self.mode = mode
        self.type = type
        
        super.init(frame: .zero)
        
        self.configureTag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func configureTag() {
        switch mode {
        case .list:
            self.listMode()
        case .mosaic:
            self.mosaicMode()
        case .none:
            break
        }
    }
    
    private func listMode() {
        self.backgroundColor = self.type?.color
        self.imageView.image = self.type?.image
        
        let label = UILabel()
        label.text = self.type?.rawValue
        label.textColor = self.type?.fontColor
        label.font = .plusJacartaSans(size: 15.0)
        
        self.addSubview(imageView)
        self.addSubview(label)
        
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(16.0)
            $0.top.bottom.equalToSuperview().inset(3.5)
            $0.leading.equalToSuperview().inset(4.0)
        }
        
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(4.0)
            $0.trailing.equalToSuperview().inset(8.0)
            $0.centerY.equalTo(imageView.snp.centerY)
        }
    }
    
    private func mosaicMode() {
        self.backgroundColor = self.type?.color
        self.imageView.image = self.type?.image
        
        self.addSubview(self.imageView)
        
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(16.0)
            $0.top.bottom.leading.trailing.equalToSuperview().inset(2.0)
        }
    }
}
