//
//  ThirdPageView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 02.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import SnapKit

final class ThirdPageView: BaseView<ThirdPageViewModel, ThirdPageOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    private let backgroundImageView = UIImageView()
    private let pokemonImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let skipButton = UIButton()
    private let goButton = UIButton()
    
    // MARK: -
    // MARK: Overrided functions
    
    override func setup() {
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.pokemonImageView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.skipButton)
        self.skipButton.addTarget(self, action: #selector(self.handleSkip), for: .touchUpInside)
        self.view.addSubview(self.goButton)
        self.goButton.addTarget(self, action: #selector(self.handleNext), for: .touchUpInside)
    }
    
    override func style() {
        self.view.backgroundColor = UIColor.wildSand()
        
        self.backgroundImageView.image = UIImage(named: "bg")
        self.pokemonImageView.image = UIImage(named: "largePokemons")
        self.titleLabelStyle()
        self.descriptionLabelStyle()
        self.skipButtonStyle()
        self.goButtonStyle()
    }
    
    override func layout() {
        self.backgroundImageViewLayout()
        self.pokemonImageViewLayout()
        self.titleLabelLayout()
        self.descriptionLabelLayout()
        self.skipButtonLayout()
        self.goButtonLayout()
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

extension ThirdPageView {
    
    // MARK: -
    // MARK: Layout
    
    private func titleLabelStyle() {
        self.titleLabel.text = "Collect them all"
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
    
    private func goButtonStyle() {
        self.goButton.setTitle("GO!", for: .normal)
        self.goButton.setTitleColor(UIColor.black, for: .normal)
        self.goButton.titleLabel?.font = UIFont.plusJacartaSans(size: 20.0)
        self.goButton.backgroundColor = UIColor.gold()
        self.goButton.layer.cornerRadius = 32.5
        self.addShadowToGoButton()
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
    
    private func goButtonLayout() {
        self.goButton.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(24.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(65.0)
            $0.width.equalTo(200.0)
        }
    }
    
    private func addShadowToGoButton() {
        self.goButton.layer.shadowColor = UIColor.darkGold().cgColor
        self.goButton.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        self.goButton.layer.shadowOpacity = 0.3
        self.goButton.layer.shadowRadius = 3.0
    }
}
