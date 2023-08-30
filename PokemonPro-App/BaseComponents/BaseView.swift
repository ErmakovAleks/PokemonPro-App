//
//  BaseView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 20.07.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxCocoa

public class BaseView<ViewModelType, OutputEventsType>: UIViewController
where ViewModelType: BaseViewModel<OutputEventsType>, OutputEventsType: Events
{
    // MARK: -
    // MARK: Accesors
    
    public var events: Observable<OutputEventsType> {
        return self.viewModel.events
    }
    
    internal let viewModel: ViewModelType
    
    private var downloadsCounter: Int = 0
    
    private let disposeBag = DisposeBag()
    private var spinnerView = UIView()
    
    // MARK: -
    // MARK: Initializations
    
    public init(viewModel: ViewModelType, nibName: String? = nil, bundle: Bundle? = nil) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: ViewController Life Cylce
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureSpinner()
        self.setup()
        self.style()
        self.layout()
        
        self.prepareBindings(disposeBag: self.disposeBag)
        self.prepare(with: self.viewModel)
        self.viewModel.viewDidLoaded()
    }
    
    //MARK: -
    //MARK: Overrding methods
    
    func setup() {
        
    }
    
    func style() {
        
    }
    
    func layout() {
        
    }
    
    func prepareBindings(disposeBag: DisposeBag) {
        
    }
    
    func prepare(with viewModel: ViewModelType) {
        
    }
    
    // MARK: -
    // MARK: Spinner Methods
    
    private func configureSpinner() {
        self.viewModel.spinnerHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .start:
                if self.downloadsCounter == 0 {
                    self.startSpinner()
                }
                
                self.downloadsCounter += 1
            case .stop:
                if self.downloadsCounter > 0 {
                    self.downloadsCounter -= 1
                }
                
                if self.downloadsCounter == 0 {
                    self.stopSpinner()
                }
            }
        }
    }
    
    public func startSpinner(view: UIView? = nil) {
        let spinner = spinner()
        
        if let view {
            view.addSubview(spinner)
            
            NSLayoutConstraint.activate([
                spinner.topAnchor.constraint(equalTo: view.topAnchor),
                spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        } else {
            self.view.addSubview(spinner)
            NSLayoutConstraint.activate([
                spinner.topAnchor.constraint(equalTo: self.view.topAnchor),
                spinner.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                spinner.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                spinner.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        }
    }
    
    private func stopSpinner() {
        self.spinnerView.removeFromSuperview()
    }
    
    private func spinner() -> UIView {
        self.spinnerView = UIView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height
            )))
        self.spinnerView.backgroundColor = .black.withAlphaComponent(0.2)
        
        let spinnerImageView = UIImageView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: 60.0, height: 60.0
            )))
        spinnerImageView.image = UIImage(named: "spinner")
        
        let spinnerBackgroundView = UIView(
            frame: CGRect(origin: .zero, size: CGSize(width: 60.0, height: 60.0
        )))
        spinnerBackgroundView.backgroundColor = .white
        spinnerBackgroundView.layer.cornerRadius = 30.0
        spinnerImageView.center = spinnerBackgroundView.center
        self.rotate(imageView: spinnerImageView, circleTime: 0.5)
        spinnerBackgroundView.addSubview(spinnerImageView)
        spinnerBackgroundView.center = self.spinnerView.center
        self.spinnerView.addSubview(spinnerBackgroundView)
        self.spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        return self.spinnerView
    }
    
    private func rotate(imageView: UIImageView, circleTime: Double) {
        UIView.animate(withDuration: circleTime/2, delay: 0.0, options: .curveLinear, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { finished in
            UIView.animate(withDuration: circleTime/2, delay: 0.0, options: .curveLinear, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
            }, completion: { finished in
                self.rotate(imageView: imageView, circleTime: circleTime)
            })
        })
    }
}
