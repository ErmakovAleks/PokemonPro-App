//
//  AboutViewModel.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 07.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

enum AboutOutputEvents: Events {
    
    case back
}

final class AboutViewModel: BaseViewModel<AboutOutputEvents> {
    
    // MARK: -
    // MARK: Internal functions
    
    func handleBack() {
        self.outputEventsEmiter.accept(.back)
    }
}
