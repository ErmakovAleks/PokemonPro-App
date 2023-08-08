//
//  DashboardViewModel.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 02.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation

enum DashboardOutputEvents: Events {
    
    case about
}

final class DashboardViewModel: BaseViewModel<DashboardOutputEvents> {
    
    // MARK: -
    // MARK: Internal functions
    
    func handleAbout() {
        self.outputEventsEmiter.accept(.about)
    }
}
