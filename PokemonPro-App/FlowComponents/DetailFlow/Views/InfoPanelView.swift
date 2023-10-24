//
//  InfoPanelView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 01.09.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import SnapKit

fileprivate enum StatisticsType {
    
    case height
    case weight
    case species
}

final class InfoPanelView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    private let item: PokemonCollectionItem
    private let baseExperience: BaseExperience
    
    private let titleLabel = UILabel()
    private let elementContainer = UIStackView()
    private let statisticsContainer = UIStackView()
    
    private var abilitiesContainer: TagsContainerView?
    private var movesContainer: TagsContainerView?
    
    // MARK: -
    // MARK: Initializators
    
    init(
        item: PokemonCollectionItem,
        baseExperience: BaseExperience,
        frame: CGRect = .zero
    ) {
        self.item = item
        self.baseExperience = baseExperience
        
        super.init(frame: frame)
        
        self.prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepare() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 24.0
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.prepareTitle()
        self.prepareElementContainer()
        self.prepareStatisticsContainer()
        self.prepareAbilitiesContainer()
        self.prepareMovesContainer()
    }
    
    private func prepareTitle() {
        self.addSubview(self.titleLabel)
        
        self.titleLabel.text = self.item.name
        self.titleLabel.font = .paytoneOneRegular(size: 36.0)
        self.titleLabel.textColor = .abbey
        self.titleLabel.textAlignment = .center
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func prepareElementContainer() {
        self.addSubview(self.elementContainer)
        
        self.elementContainer.axis = .horizontal
        self.elementContainer.spacing = 8.0
        self.elementContainer.alignment = .center
        self.elementContainer.distribution = .fill
        
        self.tags().forEach { tag in
            self.elementContainer.addArrangedSubview(tag)
        }
        
        self.elementContainer.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(12.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(23.0)
        }
    }
    
    private func prepareStatisticsContainer() {
        self.addSubview(self.statisticsContainer)
        
        self.statistics().forEach { statistics in
            self.statisticsContainer.addArrangedSubview(statistics)
        }
        
        self.statisticsContainer.snp.makeConstraints {
            $0.top.equalTo(self.elementContainer.snp.bottom).offset(24.0)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func prepareAbilitiesContainer() {
        
    }
    
    private func prepareMovesContainer() {
        
    }
    
    private func tags() -> [UIView] {
        var pokoTags: [UIView] = self.item.types.map {
            let view = TagView(mode: .list, type: $0)
            view.layer.cornerRadius = view.intrinsicContentSize.height / 2.0
            
            return view
        }
        
        return pokoTags
    }
    
    private func statistics() -> [UIView] {
        [
            self.statisticsItem(type: .height),
            self.statisticsSpacer(),
            self.statisticsItem(type: .weight),
            self.statisticsSpacer(),
            self.statisticsItem(type: .species)
        ]
    }
    
    private func statisticsItem(type: StatisticsType) -> UIView {
        let valueLabel = UILabel()
        valueLabel.font = .plusJacartaSans(size: 24.0)
        valueLabel.textColor = .abbey
        valueLabel.textAlignment = .center
        valueLabel.sizeToFit()
        
        let typeLabel = UILabel()
        typeLabel.font = .plusJacartaSans(size: 12.0)
        typeLabel.textColor = .heather
        typeLabel.textAlignment = .center
        typeLabel.sizeToFit()
        
        switch type {
        case .height:
            valueLabel.text = self.item.height.description + " cm"
            typeLabel.text = "Height"
        case .weight:
            valueLabel.text = self.item.weight.description + " kg"
            typeLabel.text = "Weight"
        case .species:
            valueLabel.text = self.baseExperience.moves.first?.move.name
            typeLabel.text = "Species"
        }
        
        let view = UIView()
        view.addSubview(valueLabel)
        view.addSubview(typeLabel)
        
        view.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(100.0)
        }
        
        valueLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8.0)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        return view
    }
    
    private func statisticsSpacer() -> UIView {
        let view = UIView()
        view.backgroundColor = .heather
        view.layer.cornerRadius = 0.5
        
        view.snp.makeConstraints {
            $0.width.equalTo(1.0)
            $0.height.equalTo(45.0)
        }
        
        return view
    }
}
