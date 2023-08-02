//
//  FirstPageViewModel.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 01.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

enum FirstPageOutputEvents: Events {
    
    case skip
    case next
}

final class FirstPageViewModel: BaseViewModel<FirstPageOutputEvents> {
    
    // MARK: -
    // MARK: Internal functions
    
    func handleSkip() {
        self.outputEventsEmiter.accept(.skip)
    }
    
    func handleNext() {
        self.outputEventsEmiter.accept(.next)
    }
}
