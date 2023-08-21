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
    /** **  */
    var testItems = BehaviorRelay<[Int]>(value: [])
    /** **  */
    private var pokemons = [Pokemon]()
    private var pokemonDetails = BehaviorRelay<[PokemonDetail]>(value: [])
    private var group = DispatchGroup()
    
    // MARK: -
    // MARK: Overrided functions
    
    override func viewDidLoaded() {
        self.getPokemons()
        let array = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.testItems.accept(array)
        }
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
    // MARK: Private functions
    
    private func getPokemons() {
        let params = PokemonsParams()
        Service.sendRequest(requestModel: params) { [weak self] result in
            switch result {
            case .success(let model):
                guard let pokemons = model.results else { return }
                self?.pokemons += pokemons
                self?.getPokemonsDetails(pokemons: pokemons)
            case .failure(let error):
                print(error.errorDescription ?? "<!> Network Error!")
            }
        }
    }
    
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
                items.append($0)
            }
        }
        
        self.group.notify(queue: .main) {
            items = items.sorted { $0.number < $1.number }
            items.insert(PokemonCollectionItem.startItem(), at: 0)
            self.items.accept(items)
        }
    }
    
    private func getOneImage(
        pokemonDetail: PokemonDetail,
        completion: @escaping (PokemonCollectionItem) -> ()
    ) {
        self.group.enter()
        Service.sendImageRequest(url: pokemonDetail.sprite) { result in
            switch result {
            case .success(let image):
                var item = PokemonCollectionItem.convert(pokemonDetail: pokemonDetail, image: image)
                completion(item)
            case .failure(let error):
                print(error.errorDescription ?? "<!> Network Error!")
            }
            
            self.group.leave()
        }
    }
}
