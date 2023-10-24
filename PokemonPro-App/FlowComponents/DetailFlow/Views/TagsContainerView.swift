//
//  TagsContainerView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 04.09.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import SnapKit

final class TagsContainerView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    private let titleLabel = UILabel()
    private let tagContainer = UIStackView()
    
    // MARK: -
    // MARK: Initializators
    
    init(
        title: String,
        items: [String],
        frame: CGRect = .zero
    ) {
        super.init(frame: frame)
        
        self.prepare(title: title, items: items)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: -
    // MARK: Private functions
    
    private func prepare(title: String, items: [String]) {
        self.prepareTitle(title: title)
        self.prepareTagContainer(tags: items)
    }
    
    private func prepareTitle(title: String) {
        self.addSubview(self.titleLabel)
        
        self.titleLabel.text = title
        self.titleLabel.font = .plusJacartaSans(size: 15.0)
        self.titleLabel.textColor = .heather
        self.titleLabel.sizeToFit()
        
        self.titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
    }
    
    private func prepareTagContainer(tags: [String]) {
        self.addSubview(self.tagContainer)
        
        self.tagContainer.axis = .vertical
        self.tagContainer.spacing = 8.0
        self.tagContainer.alignment = .leading
        self.tagContainer.distribution = .fill
        
        self.horizontalStacks(tags: tags).forEach { stack in
            self.tagContainer.addArrangedSubview(stack)
        }
        
        self.tagContainer.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func horizontalStacks(tags: [String]) -> [UIStackView] {
        
        
        return []
    }
}
/**
 1) реализовать функцию, генерирующую один горизонтальный стек
 2) на основе существующего класса TagView сделать аналогичный для этого стека
 */
