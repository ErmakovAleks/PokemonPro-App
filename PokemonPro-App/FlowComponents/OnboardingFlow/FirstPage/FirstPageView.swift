//
//  FirstPageView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 01.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import SnapKit

final class FirstPageView: BaseView<FirstPageViewModel, FirstPageOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    private let backgroundImageView = UIImageView()
    private let pokemonImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let skipButton = UIButton()
    private let nextButton = UIButton()
    
    // MARK: -
    // MARK: Overrided functions
    
    override func setup() {
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.pokemonImageView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.skipButton)
        self.skipButton.addTarget(self, action: #selector(self.handleSkip), for: .touchUpInside)
        self.view.addSubview(self.nextButton)
        self.nextButton.addTarget(self, action: #selector(self.handleNext), for: .touchUpInside)
    }
    
    override func style() {
        self.view.backgroundColor = UIColor.wildSand()
        
        self.backgroundImageView.image = UIImage(named: "bg")
        self.pokemonImageView.image = UIImage(named: "largeSilhouette")
        self.titleLabelStyle()
        self.descriptionLabelStyle()
        self.skipButtonStyle()
        self.nextButtonStyle()
    }
    
    override func layout() {
        self.backgroundImageViewLayout()
        self.pokemonImageViewLayout()
        self.titleLabelLayout()
        self.descriptionLabelLayout()
        self.skipButtonLayout()
        self.nextButtonLayout()
    }
    
    // MARK: -
    // MARK: Private functions
    
    @objc func handleSkip() {
        self.viewModel.handleSkip()
    }
    
    @objc func handleNext() {
        self.viewModel.handleNext()
    }
}

extension FirstPageView {
    
    // MARK: -
    // MARK: Layout
    
    private func titleLabelStyle() {
        self.titleLabel.text = "Find out who"
        self.titleLabel.font = UIFont.paytoneOneRegular(size: 24.0)
        self.titleLabel.textAlignment = .center
    }
    
    private func descriptionLabelStyle() {
        self.descriptionLabel.text = "IFunny is fun of your life. Images, GIFs and videos featured seven times a day. Your anaconda definitely wants some."
        self.descriptionLabel.font = UIFont.plusJacartaSans(size: 15.0)
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.numberOfLines = 0
    }
    
    private func skipButtonStyle() {
        self.skipButton.setTitle("Skip", for: .normal)
        self.skipButton.setTitleColor(UIColor.gold(), for: .normal)
        self.skipButton.titleLabel?.font = UIFont.plusJacartaSans(size: 15.0)
    }
    
    private func nextButtonStyle() {
        self.nextButton.setTitle("Next", for: .normal)
        self.nextButton.setTitleColor(UIColor.gold(), for: .normal)
        self.nextButton.titleLabel?.font = UIFont.plusJacartaSans(size: 15.0)
    }
    
    private func backgroundImageViewLayout() {
        self.backgroundImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(28.0)
            $0.top.equalToSuperview().inset(118.0)
            $0.height.equalTo(self.backgroundImageView.snp.width).multipliedBy(328/317)
        }
    }
    
    private func pokemonImageViewLayout() {
        self.pokemonImageView.snp.makeConstraints {
            $0.center.equalTo(self.backgroundImageView.snp.center)
            $0.horizontalEdges.equalTo(self.backgroundImageView.snp.horizontalEdges).inset(16.0)
            $0.verticalEdges.equalTo(self.backgroundImageView.snp.verticalEdges).inset(20.0)
        }
    }
    
    private func titleLabelLayout() {
        self.titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(self.backgroundImageView.snp.bottom).offset(96.0)
        }
    }
    
    private func descriptionLabelLayout() {
        self.descriptionLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32.0)
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(24.0)
        }
    }
    
    private func skipButtonLayout() {
        self.skipButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(34.0)
            $0.leading.equalToSuperview().inset(24.0)
        }
    }
    
    private func nextButtonLayout() {
        self.nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(34.0)
            $0.trailing.equalToSuperview().inset(24.0)
        }
    }
}
