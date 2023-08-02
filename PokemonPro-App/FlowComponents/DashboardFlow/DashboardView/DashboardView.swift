//
//  DashboardView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 02.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

final class DashboardView: BaseView<DashboardViewModel, DashboardOutputEvents> {
    
    // MARK: -
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemPurple
    }
}
