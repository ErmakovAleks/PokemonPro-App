//
//  MainCoordinator.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 28.07.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

import RxRelay
import RxSwift

final class MainCoordinator: BaseCoordinator {
    
    // MARK: -
    // MARK: Variables
    
    private var onboardingViewController: OnboardingViewController?
    
    // MARK: -
    // MARK: Coordinator Life Cycle
    
    override func start() {
        let onboardingViewController = OnboardingViewController(
            pages: [self.firstPageView(), self.secondPageView(), self.thirdPageView()]
        )
        
        self.onboardingViewController = onboardingViewController
        
        self.pushViewController(onboardingViewController, animated: true)
    }
    
    // MARK: -
    // MARK: Onboarding ViewController
    
    private func firstPageView() -> FirstPageView {
        let viewModel = FirstPageViewModel()
        let view = FirstPageView(viewModel: viewModel)
        
        viewModel.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return view
    }
    
    private func handle(events: FirstPageOutputEvents) {
        switch events {
        case .skip:
            self.skipToDashboard()
        case .next:
            self.handleNext()
        }
    }
    
    private func secondPageView() -> SecondPageView {
        let viewModel = SecondPageViewModel()
        let view = SecondPageView(viewModel: viewModel)
        
        viewModel.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return view
    }
    
    private func handle(events: SecondPageOutputEvents) {
        switch events {
        case .skip:
            self.skipToDashboard()
        case .next:
            self.handleNext()
        }
    }
    
    private func thirdPageView() -> ThirdPageView {
        let viewModel = ThirdPageViewModel()
        let view = ThirdPageView(viewModel: viewModel)
        
        viewModel.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return view
    }
    
    private func handle(events: ThirdPageOutputEvents) {
        switch events {
        case .skip:
            self.skipToDashboard()
        case .next:
            self.skipToDashboard()
        }
    }
    
    private func handleNext() {
        self.onboardingViewController?.nextHandler?()
    }
    
    // MARK: -
    // MARK: Dashboard functions
    
    private func dashboardView() -> DashboardView {
        let viewModel = DashboardViewModel()
        let view = DashboardView(viewModel: viewModel)
        
        return view
    }
    
    private func skipToDashboard() {
        let dashboardView = self.dashboardView()
        self.setViewControllers([dashboardView], animated: true)
    }
}
