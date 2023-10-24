//
//  DetailView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 30.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import RxSwift
import RxRelay
import SnapKit

final class DetailView: BaseView<DetailViewModel, DetailOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    private let item: PokemonCollectionItem
    
    private let fullImageContainer = UIView()
    private let bluredView = UIView()
    private let innerCircleView = UIView()
    private let whiteBackgroundView = UIView()
    private let imageView = UIImageView()
    private let baseExperienceIndicatorBackgroundView = UIView()
    private let baseExperienceIndicatorView = UIView()
    
    private var infoPanelView: InfoPanelView?
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [UIColor.green.cgColor, UIColor.systemPurple.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return gradient
    }()
    
    // MARK: -
    // MARK: Initializators
    
    init(item: PokemonCollectionItem, viewModel: DetailViewModel) {
        self.item = item
        
        super.init(viewModel: viewModel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.getBaseExperience(url: item.detailURL)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        self.baseExperienceIndicatorBackgroundView.layoutSubviews()
        self.refreshGradient()
    }
    
    // MARK: -
    // MARK: Overrided functions
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.baseExperienceModel.bind { [weak self] in
            self?.bluredViewLayout(baseExperience: $0.baseExperience)
            self?.baseExperienceIndicatorViewSetup(baseExperience: $0.baseExperience)
            self?.infoPanelViewSetup(
                item: self?.item ?? PokemonCollectionItem.startItem(),
                baseExperience: $0
            )
            
            self?.infoPanelViewLayout()
            self?.view.layoutSubviews()
        }
        .disposed(by: disposeBag)
    }
    
    override func setup() {
        self.item.image.getColors { color in
            self.view.backgroundColor = color.background.normalizedColor()
        }
        
        self.navigationItemSetup()
        self.imageViewSetup()
    }
    
    override func style() {
        self.fullImageContainerStyle()
        self.bluredViewStyle()
        self.innerCircleViewStyle()
        self.whiteBackgroundViewStyle()
        self.imageViewStyle()
        self.baseExperienceIndicatorBackgroundViewStyle()
        self.baseExperienceIndicatorViewStyle()
    }
    
    override func layout() {
        self.fullImageContainerLayout()
        self.innerCircleViewLayout()
        self.whiteBackgroundViewLayout()
        self.imageViewLayout()
        self.baseExperienceIndicatorBackgroundViewLayout()
        self.baseExperienceIndicatorViewLayout()
        self.infoPanelViewLayout()
    }
    
    // MARK: -
    // MARK: NavigationBar functions
    
    private func navigationItemSetup() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.titleTextAttributes =
        [
            NSAttributedString.Key.font : UIFont.plusJacartaSans(size: 24.0),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        self.navigationItem.title = "Base expirience"
        let backButtonItem = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(self.handleBackButton)
        )
        
        self.navigationItem.setLeftBarButton(backButtonItem, animated: false)
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        
        let rightButtonItem = UIBarButtonItem(
            title: self.item.number.toBondFormat(),
            style: .plain,
            target: nil,
            action: nil
        )
        
        self.navigationItem.setRightBarButton(rightButtonItem, animated: false)
        rightButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.plusJacartaSans(size: 24.0),
                NSAttributedString.Key.foregroundColor : UIColor.white
            ],
            for: .disabled
        )
    }
    
    // MARK: -
    // MARK: Full Image Container functions
    
    private func fullImageContainerStyle() {
        self.fullImageContainer.backgroundColor = .clear
    }
    
    private func fullImageContainerLayout() {
        self.view.addSubview(self.fullImageContainer)
        
        self.fullImageContainer.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300.0)
            $0.height.equalTo(310.0)
        }
    }
    
    // MARK: -
    // MARK: Blured View functions
    
    private func bluredViewStyle() {
        self.bluredView.backgroundColor = .white.withAlphaComponent(0.3)
        self.bluredView.layer.cornerRadius = 150.0
    }
    
    private func bluredViewLayout(baseExperience: Int) {
        self.fullImageContainer.addSubview(self.bluredView)
        
        self.bluredView.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.size.equalTo(300.0)
        }
        
        let gradientArcView = GradientArcView(baseExperience: baseExperience)
        self.bluredView.addSubview(gradientArcView)
        self.bluredView.sendSubviewToBack(gradientArcView)

        gradientArcView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(296.0)
        }
    }
    
    // MARK: -
    // MARK: Inner Circle View functions
    
    private func innerCircleViewStyle() {
        self.innerCircleView.layer.cornerRadius = 138.0
        self.item.image.getColors { color in
            self.innerCircleView.backgroundColor = color.background.normalizedColor()
        }
    }
    
    private func innerCircleViewLayout() {
        self.bluredView.addSubview(self.innerCircleView)
        
        self.innerCircleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(276.0)
        }
    }
    
    // MARK: -
    // MARK: White Background View functions
    
    private func whiteBackgroundViewStyle() {
        self.whiteBackgroundView.backgroundColor = .white
        self.whiteBackgroundView.layer.cornerRadius = 132.0
    }
    
    private func whiteBackgroundViewLayout() {
        self.innerCircleView.addSubview(self.whiteBackgroundView)
        
        self.whiteBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(264.0)
        }
    }
    
    // MARK: -
    // MARK: Image View functions
    
    private func imageViewSetup() {
        self.imageView.image = self.item.image
    }
    
    private func imageViewStyle() {
        self.imageView.backgroundColor = .white
        self.imageView.layer.cornerRadius = 110.0
    }
    
    private func imageViewLayout() {
        self.whiteBackgroundView.addSubview(self.imageView)
        
        self.imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(220.0)
        }
    }
    
    // MARK: -
    // MARK: Base Experience Indicator Background View functions
    
    private func baseExperienceIndicatorBackgroundViewStyle() {
        self.baseExperienceIndicatorBackgroundView.backgroundColor = .clear
    }
    
    private func baseExperienceIndicatorBackgroundViewLayout() {
        self.whiteBackgroundView.addSubview(self.baseExperienceIndicatorBackgroundView)
        
        self.baseExperienceIndicatorBackgroundView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-18.0)
            $0.trailing.bottom.equalToSuperview().offset(18.0)
            $0.top.equalToSuperview().offset(-28.0)
        }
    }
    
    // MARK: -
    // MARK: Base Experience Indicator View functions
    
    private func baseExperienceIndicatorViewSetup(baseExperience: Int) {
        let label = UILabel()
        label.text = baseExperience.description
        label.font = UIFont.plusJacartaSans(size: 15.0)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        
        self.baseExperienceIndicatorView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func baseExperienceIndicatorViewStyle() {
        self.baseExperienceIndicatorView.layer.addSublayer(self.gradient)
        self.baseExperienceIndicatorView.layer.cornerRadius = 15.0
        self.baseExperienceIndicatorView.layer.masksToBounds = true
    }
    
    private func baseExperienceIndicatorViewLayout() {
        self.baseExperienceIndicatorBackgroundView.addSubview(self.baseExperienceIndicatorView)
        
        self.baseExperienceIndicatorView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.height.equalTo(30.0)
        }
    }
    
    private func refreshGradient() {
        self.gradient.frame = self.baseExperienceIndicatorView.bounds
    }
    
    // MARK: -
    // MARK: Info Panel View funcitons
    
    private func infoPanelViewSetup(item: PokemonCollectionItem, baseExperience: BaseExperience) {
        self.infoPanelView = InfoPanelView(item: item, baseExperience: baseExperience)
    }
    
    private func infoPanelViewLayout() {
        self.view.addSubview(self.infoPanelView ?? UIView())
        
        self.infoPanelView?.snp.makeConstraints {
            $0.top.equalTo(self.fullImageContainer.snp.bottom).offset(16.0)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: -
    // MARK: Private functions
    
    @objc private func handleBackButton() {
        self.viewModel.handleBack()
    }
}


