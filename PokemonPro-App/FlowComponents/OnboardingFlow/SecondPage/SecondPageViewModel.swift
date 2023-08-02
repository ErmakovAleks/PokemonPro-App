//
//  SecondPageViewModel.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 02.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

enum SecondPageOutputEvents: Events {
    
    case skip
    case next
}

final class SecondPageViewModel: BaseViewModel<SecondPageOutputEvents> {
    
    // MARK: -
    // MARK: Internal functions
    
    func handleSkip() {
        self.outputEventsEmiter.accept(.skip)
    }
    
    func handleNext() {
        self.outputEventsEmiter.accept(.next)
    }
}
