//
//  GradientArcView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 31.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class GradientArcView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    private var baseExperience: Int?
    private var endAngle: CGFloat?
    
    private let maxBaseExperience = 608

    private let gradientLayer = CAGradientLayer()

    init(baseExperience: Int, frame: CGRect = .zero) {
        self.baseExperience = baseExperience
        
        super.init(frame: frame)

        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.updateGradient()
    }
}

private extension GradientArcView {
    
    func configure() {
        self.endAngle = (-90.0 - CGFloat((self.baseExperience ?? 0) * 360 / self.maxBaseExperience)) * .pi / 180.0
        
        let startPoint = CGPoint(x: 0.5, y: 0.0)
        let endPoint = CGPoint(
            x: startPoint.x + cos(self.endAngle ?? 0.0) / 2.0,
            y: 0.5 + sin(self.endAngle ?? 0.0) / 2.0
        )
        
        self.gradientLayer.type = .axial
        self.gradientLayer.startPoint = startPoint
        self.gradientLayer.endPoint = endPoint
        
        layer.addSublayer(self.gradientLayer)
    }

    func updateGradient() {
        self.gradientLayer.frame = bounds
        self.gradientLayer.colors = [UIColor.green, UIColor.systemPurple].map { $0.cgColor }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - 8) / 2
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2.0,
            endAngle: self.endAngle ?? 0.0,
            clockwise: false
        )
        
        let mask = CAShapeLayer()
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = 8
        mask.path = path.cgPath
        self.gradientLayer.mask = mask
    }
}
