//
//  ThirdPageViewModel.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 02.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

enum ThirdPageOutputEvents: Events {
    
    case skip
    case next
}

final class ThirdPageViewModel: BaseViewModel<ThirdPageOutputEvents> {
    
    // MARK: -
    // MARK: Internal functions
    
    func handleSkip() {
        self.outputEventsEmiter.accept(.skip)
    }
    
    func handleNext() {
        self.outputEventsEmiter.accept(.next)
    }
}
