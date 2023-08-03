//
//  ViewController.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 19.07.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

import SnapKit

class OnboardingViewController: UIPageViewController {
    
    // MARK: -
    // MARK: Variables
    
    internal var nextHandler: (() -> ())?
    
    private let pages: [UIViewController]
    private let pageControl = UIPageControl()
    private let stackView = UIStackView()
    private let initialPage = 0
    
    // MARK: -
    // MARK: Initializations
    
    init(pages: [UIViewController]) {
        self.pages = pages
        
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepare()
        self.preparePageControl()
        self.prepareStackView()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepare() {
        self.delegate = self
        self.dataSource = self
        self.stackView.distribution = .fillEqually
        
        self.nextHandler = {
            guard let current = self.viewControllers?.first else { return }
            guard let next = self.pageViewController(self, viewControllerAfter: current) else { return }
            
            self.setViewControllers([next], direction: .forward, animated: true) { _ in
                self.pageViewController(
                    self, didFinishAnimating: true,
                    previousViewControllers: [current],
                    transitionCompleted: true
                )
            }
        }
        
        self.setViewControllers([self.pages[initialPage]], direction: .forward, animated: true)
    }
    
    private func preparePageControl() {
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = self.initialPage
        self.pageControl.preferredCurrentPageIndicatorImage = UIImage(named: "currentIndicator")
        self.pageControl.preferredIndicatorImage = UIImage(named: "prefferedIndicator")
        self.pageControl.pageIndicatorTintColor = UIColor.abbey()
        self.pageControl.currentPageIndicatorTintColor = UIColor.abbey()
        
        self.view.addSubview(self.pageControl)
        
        self.pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(29.0)
            $0.bottom.equalToSuperview().inset(34.0)
        }
    }
    
    private func prepareStackView() {
        self.stackView.axis = .horizontal
        let pageControlButtons = self.pages.map { _ in
            let button = UIButton()
            button.addTarget(
                self,
                action: #selector(self.handleSpecificPage),
                for: .touchUpInside
            )
            
            self.stackView.addArrangedSubview(button)
            
            return button
        }
        
        self.view.addSubview(self.stackView)
        
        self.stackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(self.pageControl.snp.verticalEdges)
            $0.width.equalTo(self.pageControl.snp.width).multipliedBy(0.5)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func handleSpecificPage(_ sender: UIButton) {
        self.stackView.arrangedSubviews.enumerated().forEach { index, button in
            if sender === button && index != self.pageControl.currentPage {
                let direction: UIPageViewController.NavigationDirection
                
                if index > self.pageControl.currentPage {
                    direction = .reverse
                } else {
                    direction = .forward
                }
                
                self.setViewControllers([self.pages[index]], direction: direction, animated: true) { _ in
                    self.pageControl.currentPage = index
                }
            }
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = self.pages.firstIndex(of: viewControllers[0]) else { return }
        
        self.pageControl.currentPage = currentIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
                
        if currentIndex == 0 {
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return pages.first
        }
    }
}
