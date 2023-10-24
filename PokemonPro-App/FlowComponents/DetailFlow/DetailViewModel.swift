//
//  DetailViewModel.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 30.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation
import RxSwift
import RxRelay

enum DetailOutputEvents: Events {
    
    case back
}

final class DetailViewModel: BaseViewModel<DetailOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    var baseExperienceModel = PublishRelay<BaseExperience>()
    
    // MARK: -
    // MARK: Internal functions
    
    func handleBack() {
        self.outputEventsEmiter.accept(.back)
    }

    func getBaseExperience(url: URL?) {
        guard let url else { return }
        self.spinnerHandler?(.start)
        Service.sendRequest(url: url, decodableType: BaseExperience.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.baseExperienceModel.accept(model)
                case .failure(let error):
                    print(error.errorDescription ?? "<!> Network Error!")
                }
                
                self?.spinnerHandler?(.stop)
            }
        }
    }
}
