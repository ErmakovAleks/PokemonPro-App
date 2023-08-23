//
//  DashboardViewModel.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 02.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import Foundation
import RxSwift
import RxRelay

enum DashboardOutputEvents: Events {
    
    case about
}

final class DashboardViewModel: BaseViewModel<DashboardOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    var items = BehaviorRelay<[PokemonCollectionItem]>(value: [])
    var itemsPreviousCount: Int = 0
    var isLoadingList: Bool = false
    var offset: Int = 0

    private var pokemons = [Pokemon]()
    private var pokemonDetails = BehaviorRelay<[PokemonDetail]>(value: [])
    private var group = DispatchGroup()

    // MARK: -
    // MARK: Overrided functions
    
    override func viewDidLoaded() {
        self.getPokemons()
    }
    
    override func prepareBindings(bag: DisposeBag) {
        self.pokemonDetails.bind { [weak self] in
            self?.getImages(pokemonDetails: $0)
        }
        .disposed(by: bag)
    }
    
    // MARK: -
    // MARK: Internal functions
    
    func handleAbout() {
        self.outputEventsEmiter.accept(.about)
    }
    
    // MARK: -
    // MARK: Internal functions
    
    func getPokemons(limit: Int = 6, offset: Int = 0) {
        let params = PokemonsParams(limit: limit, offset: offset)
        Service.sendRequest(requestModel: params) { [weak self] result in
            switch result {
            case .success(let model):
                guard let pokemons = model.results else { return }
                self?.pokemons = pokemons
                self?.getPokemonsDetails(pokemons: pokemons)
            case .failure(let error):
                print(error.errorDescription ?? "<!> Network Error!")
            }
        }
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func getPokemonsDetails(pokemons: [Pokemon]) {
        var details = [PokemonDetail]()
        pokemons.forEach { [weak self] pokemon in
            self?.getOnePokemonDetail(name: pokemon.name) { detail in
                details += detail
            }
        }

        self.group.notify(queue: .main) {
            let filteredDetails = details
                .filter { pokemonDetail in
                    self.pokemons.contains { pokemon in
                        pokemon.name == pokemonDetail.name.lowercased()
                    }
                }
                
            self.pokemonDetails.accept(filteredDetails)
        }
    }
    
    private func getOnePokemonDetail(
        name: String,
        completion: @escaping ([PokemonDetail]) -> ()
    ) {
        let params = PokemonDetailParams(name: name)
        self.group.enter()
        Service.sendRequest(requestModel: params) { result in
            switch result {
            case .success(let model):
                completion(model)
            case .failure(let error):
                print(error.errorDescription ?? "<!> Network Error!")
            }
            
            self.group.leave()
        }
    }
    
    private func getImages(pokemonDetails: [PokemonDetail]) {
        guard !pokemonDetails.isEmpty else { return }
        
        var items = [PokemonCollectionItem]()
        pokemonDetails.forEach {
            self.getOneImage(pokemonDetail: $0) {
                switch $0 {
                case .success(let model):
                    items.append(model)
                case .failure(_):
                    break
                }
            }
        }
        
        self.group.notify(queue: .main) {
            items = items.sorted { $0.number < $1.number }
            self.offset += items.count
    
            if self.items.value.isEmpty {
                items.insert(PokemonCollectionItem.startItem(), at: 0)
            }
            
            if !items.isEmpty {
                self.itemsPreviousCount = self.items.value.count
                self.items.accept(self.items.value + items)
                self.isLoadingList = false
            }
        }
    }
    
    private func getOneImage(
        pokemonDetail: PokemonDetail,
        completion: @escaping (ResultCompletion<PokemonCollectionItem>)
    ) {
        self.group.enter()
        Service.sendImageRequest(url: pokemonDetail.sprite) { result in
            switch result {
            case .success(let image):
                var item = PokemonCollectionItem.convert(pokemonDetail: pokemonDetail, image: image)
                completion(.success(item))
            case .failure(let error):
                completion(.failure(error))
                print(error.errorDescription ?? "<!> Network Error!")
            }
            
            self.group.leave()
        }
    }
}
