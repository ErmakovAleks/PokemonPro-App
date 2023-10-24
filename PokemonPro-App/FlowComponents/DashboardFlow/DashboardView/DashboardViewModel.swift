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
    case detail(PokemonCollectionItem)
}

final class DashboardViewModel: BaseViewModel<DashboardOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    var items = BehaviorRelay<[PokemonCollectionItem]>(value: [])
    var isLoadingList: Bool = false
    var offset: Int = 0

    private var allPokemons = [Pokemon]()
    private var pokemonDetails = BehaviorRelay<[PokemonDetail]>(value: [])
    private var group = DispatchGroup()

    // MARK: -
    // MARK: Overrided functions
    
    override func viewDidLoaded() {
        self.getPokemons()
        self.getAllPokemonNames()
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
    
    func getNextPage() {
        self.getPokemons(offset: self.offset)
    }
    
    func searchOf(text: String) {
        let searchedPokemons = self.allPokemons.filter { $0.name.contains(text.lowercased()) }
        self.items.accept([])
        self.getPokemonsDetails(pokemons: searchedPokemons)
    }
    
    func showDetailFor(item: PokemonCollectionItem) {
        self.outputEventsEmiter.accept(.detail(item))
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func getPokemons(offset: Int = 0) {
        self.spinnerHandler?(.start)
        let params = PokemonsParams(offset: offset)
        Service.sendRequest(requestModel: params) { [weak self] result in
            switch result {
            case .success(let model):
                guard let pokemons = model.results else { return }
                self?.getPokemonsDetails(pokemons: pokemons)
            case .failure(let error):
                print(error.errorDescription ?? "<!> Network Error!")
            }
        }
    }
    
    private func getAllPokemonNames() {
        let params = PokemonsParams(offset: self.allPokemons.count)
        Service.sendRequest(requestModel: params) { [weak self] result in
            switch result {
            case .success(let model):
                guard let pokemons = model.results else { return }
                self?.allPokemons += pokemons
                if model.next != nil {
                    self?.getAllPokemonNames()
                }
            case .failure(let error):
                print(error.errorDescription ?? "<!> Network Error!")
            }
        }
    }
    
    private func getPokemonsDetails(pokemons: [Pokemon]) {
        var details = [PokemonDetail]()
        pokemons.forEach { [weak self] pokemon in
            self?.getOnePokemonDetail(name: pokemon.name) { detail in
                let fullModels = detail.map {
                    var model = $0
                    model.detailURL = pokemon.url
                    
                    return model
                }
                
                details += fullModels
            }
        }

        self.group.notify(queue: .main) {
            let filteredDetails = details
                .filter { pokemonDetail in
                    pokemons.contains { pokemon in
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
            
            if !items.isEmpty {
                self.items.accept(self.items.value + items)
                self.isLoadingList = false
                self.spinnerHandler?(.stop)
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
                let item = PokemonCollectionItem.convert(pokemonDetail: pokemonDetail, image: image)
                completion(.success(item))
            case .failure(let error):
                completion(.failure(error))
                print(error.errorDescription ?? "<!> Network Error!")
            }
            
            self.group.leave()
        }
    }
}
