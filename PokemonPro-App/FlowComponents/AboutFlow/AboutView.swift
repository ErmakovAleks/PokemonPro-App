//
//  AboutView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 07.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit
import SnapKit

final class AboutView: BaseView<AboutViewModel, AboutOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    private let scrollView = UIScrollView()
    private let textView = UITextView()
    
    // MARK: -
    // MARK: Overrided functions
    
    override func setup() {
        self.navigationItemSetup()
        self.scrollViewSetup()
        self.textViewSetup()
    }
    
    override func style() {
        self.view.backgroundColor = .wildSand
        self.textViewStyle()
    }
    
    override func layout() {
        self.scrollViewLayout()
        self.textViewLayout()
    }
    
    // MARK: -
    // MARK: NavigationBar functions
    
    private func navigationItemSetup() {
        self.navigationItem.title = "About us"
        let backItem = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(self.handleBackButton)
        )
        
        self.navigationItem.setLeftBarButton(backItem, animated: false)
    }
    
    // MARK: -
    // MARK: ScrollView functions
    
    private func scrollViewSetup() {
        self.view.addSubview(self.scrollView)
    }
    
    private func scrollViewLayout() {
        self.scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
        }
    }
    
    // MARK: -
    // MARK: TextView functions
    
    private func textViewSetup() {
        self.scrollView.addSubview(self.textView)
    }
    
    private func textViewStyle() {
        let text =
"""
Lorem ipsum dolor sit amet consectetur. Bibendum nibh ornare ultricies bibendum pretium sed senectus. Nulla rhoncus lacus turpis faucibus phasellus nec mattis nullam. Turpis leo egestas nec lorem volutpat eget mauris sed amet. Dignissim orci pharetra blandit urna nunc.Lorem ipsum dolor sit amet consectetur. Bibendum nibh ornare ultricies bibendum pretium sed senectus. Nulla rhoncus lacus turpis faucibus phasellus nec mattis nullam. Turpis leo egestas nec lorem volutpat eget mauris sed amet. Dignissim orci pharetra blandit urna nunc.Lorem ipsum dolor sit amet consectetur. Bibendum nibh ornare ultricies bibendum pretium sed senectus. Nulla rhoncus lacus turpis faucibus phasellus nec mattis nullam. Turpis leo egestas nec lorem volutpat eget mauris sed amet. Dignissim orci pharetra blandit urna nunc.Lorem ipsum dolor sit amet consectetur. Bibendum nibh ornare ultricies bibendum pretium sed senectus. Nulla rhoncus lacus turpis faucibus phasellus nec mattis nullam. Turpis leo egestas nec lorem volutpat eget mauris sed amet. Dignissim orci pharetra blandit urna nunc.
"""
        let textViewAttributes: [NSAttributedString.Key:Any] = [
            .font: UIFont.plusJacartaSans(size: 15.0),
            .foregroundColor: UIColor.abbey,
            .paragraphStyle: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = 15.0
                return paragraph
            }()
        ]
        
        self.textView.backgroundColor = .wildSand
        self.textView.attributedText = NSAttributedString(
            string: text,
            attributes: textViewAttributes
        )
    }
    
    private func textViewLayout() {
        self.textView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view).inset(24.0)
            $0.width.height.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: -
    // MARK: Private functions
    
    @objc private func handleBackButton() {
        self.viewModel.handleBack()
    }
}
