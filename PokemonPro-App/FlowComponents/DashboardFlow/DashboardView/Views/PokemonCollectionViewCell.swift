//
//  PokemonCollectionViewCell.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 14.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import SnapKit

enum RepresentMode {
    
    case list
    case mosaic
}

class PokemonCollectionViewCell: UICollectionViewCell {
    
    // MARK: -
    // MARK: UI Elements
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "whatPokemon")
        
        return imageView
    }()
    
    private let circleView = UIView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .abbey
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .paytoneOneRegular(size: 22.0)
        
        return label
    }()
    
    private let tagContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        
        return stackView
    }()
       
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sand
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .plusJacartaSans(size: 12.0)
        
        return label
    }()
    
    private let descriptionContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        
        return stackView
    }()
    
    private var types = [PokeType]()
    
    // MARK: -
    // MARK: CollectionViewCell Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 14.0
        
        self.prepareCircleView()
        self.preparePokemonImage()
        self.prepareDescriptionContainer()
        self.applyShadow(cornerRadius: 14.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Internal functions
    
    func configure(with model: PokemonCollectionItem, index: Int) {
        self.pokemonImageView.image = model.image
        self.nameLabel.text = model.name
        self.types = model.types
        self.tags(types: model.types).forEach { tag in
            self.tagContainer.addArrangedSubview(tag)
        }
        
        self.numberLabel.text = (index + 1).toBondFormat()
        model.image.getColors { colors in
            self.circleView.backgroundColor = colors.background.normalizedColor()
        }
    }
    
    func switchMode(to mode: RepresentMode) {
        switch mode {
        case .list:
            self.prepareListMode()
        case .mosaic:
            self.prepareMosaicMode()
        }
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func preparePokemonImage() {
        self.contentView.addSubview(self.pokemonImageView)
        self.pokemonImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.pokemonImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16.0)
            $0.bottom.greaterThanOrEqualToSuperview().inset(16.0)
            $0.height.width.equalTo(95.0)
        }
    }
    
    private func prepareCircleView() {
        self.contentView.addSubview(self.circleView)
        self.circleView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.circleView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16.0)
            $0.bottom.greaterThanOrEqualToSuperview().inset(16.0)
            $0.height.width.equalTo(95.0)
        }
        
        self.layoutIfNeeded()
        self.circleView.layer.cornerRadius = self.circleView.frame.width / 2
    }
    
    private func prepareDescriptionContainer() {
        self.descriptionContainer.addArrangedSubview(self.nameLabel)
        self.descriptionContainer.addArrangedSubview(self.tagContainer)
        self.descriptionContainer.addArrangedSubview(self.numberLabel)
        self.contentView.addSubview(self.descriptionContainer)
        
        self.descriptionContainer.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(16.0)
            $0.leading.equalTo(self.pokemonImageView.snp.trailing).offset(16.0)
        }
    }
    
    private func tags(types: [PokeType], mode: RepresentMode = .list) -> [UIView] {
        var pokoTags: [UIView] = types.map {
            let view = TagView(mode: mode, type: $0)
            view.layer.cornerRadius = view.intrinsicContentSize.height / 2.0
            
            return view
        }
        
        let spacer = UIView(
            frame: CGRect(origin: .zero, size: CGSize(width: 1.0, height: 10.0))
        )
        
        spacer.backgroundColor = .clear
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        spacer.snp.makeConstraints {
            $0.height.width.greaterThanOrEqualTo(10.0)
        }
        
        pokoTags.append(spacer)
        
        return pokoTags
    }
    
    // MARK: -
    // MARK: List Mode Layout
    
    private func prepareListMode() {
        self.numberLabel.removeFromSuperview()
        
        self.circleView.snp.remakeConstraints {
            $0.top.leading.equalToSuperview().inset(16.0)
            $0.bottom.greaterThanOrEqualToSuperview().inset(16.0)
            $0.height.width.equalTo(95.0)
        }
        
        self.pokemonImageView.snp.remakeConstraints {
            $0.top.leading.equalToSuperview().inset(16.0)
            $0.bottom.greaterThanOrEqualToSuperview().inset(16.0)
            $0.height.width.equalTo(95.0)
        }
        
        self.descriptionContainer.removeAllArrangedSubviews()
        self.nameLabel.textAlignment = .left
        self.tagContainer.removeAllArrangedSubviews()
        self.tags(types: self.types, mode: .list).forEach { tag in
            self.tagContainer.addArrangedSubview(tag)
        }
        
        self.descriptionContainer.addArrangedSubview(self.nameLabel)
        self.descriptionContainer.addArrangedSubview(self.tagContainer)
        self.descriptionContainer.addArrangedSubview(self.numberLabel)
        
        self.descriptionContainer.snp.remakeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(16.0)
            $0.leading.equalTo(self.pokemonImageView.snp.trailing).offset(16.0)
        }
    }
    
    private func prepareMosaicMode() {
        self.contentView.addSubview(self.numberLabel)
        self.numberLabel.snp.remakeConstraints {
            $0.top.trailing.equalToSuperview().inset(8.0)
        }
        
        self.circleView.snp.remakeConstraints {
            $0.top.equalTo(self.numberLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(95.0)
        }
        
        self.pokemonImageView.snp.remakeConstraints {
            $0.top.equalTo(self.numberLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(95.0)
        }
        
        self.descriptionContainer.removeAllArrangedSubviews()
        self.nameLabel.textAlignment = .center
        self.tagContainer.removeAllArrangedSubviews()
        self.tags(types: self.types, mode: .mosaic).dropLast().forEach { tag in
            self.tagContainer.addArrangedSubview(tag)
        }
        
        let tagContainerView = UIView()
        tagContainerView.addSubview(tagContainer)
        
        self.tagContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        self.descriptionContainer.addArrangedSubview(self.nameLabel)
        self.descriptionContainer.addArrangedSubview(tagContainerView)
        
        self.descriptionContainer.snp.remakeConstraints {
            $0.top.equalTo(self.pokemonImageView.snp.bottom).offset(4.0)
            $0.leading.trailing.equalToSuperview().inset(8.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
    }
}
