//
//  BaseViewModel.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 20.07.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

import RxSwift
import RxCocoa

public class BaseViewModel<OutputEventsType: Events>: NetworkServiceContainable {
    
    //MARK: -
    //MARK: Variables
    
    public var events: Observable<OutputEventsType> {
        return self.outputEventsEmiter.asObservable()
    }
    
    public let disposeBag = DisposeBag()
    
    internal let outputEventsEmiter = PublishRelay<OutputEventsType>()
    
    //MARK: -
    //MARK: Initializations
    
    public init() {
        self.prepareBindings(bag: self.disposeBag)
    }

    //MARK: -
    //MARK: Overriding

    func prepareBindings(bag: DisposeBag) {
        
    }
    
    func viewDidLoaded() {
        
    }
}
