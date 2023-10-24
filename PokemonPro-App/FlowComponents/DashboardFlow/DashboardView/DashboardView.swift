//
//  DashboardView.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 02.08.2023.
//  Copyright © 2023 IDAP. All rights reserved.


fileprivate extension Constants {
    
    static let animationTime: CGFloat = 0.25
    static let alphaAnimationTime: CGFloat = 0.1
}

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class DashboardView: BaseView<DashboardViewModel, DashboardOutputEvents> {

    // MARK: -
    // MARK: Variables
    
    private let titleContainerView = UIView()
    private let titleLabel = UILabel()
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(
            DashboardView.self,
            action: #selector(refreshCollection(sender:)),
            for: .valueChanged
        )
        
        return refresh
    }()
    
    private var collectionView: UICollectionView?
    private var collectionLayout: ItemHeightDelegateContainable?
    private var layoutMode: RepresentMode = .list
    private var downloadedPokemons = [PokemonCollectionItem]()
    private var pokemonsToShow = BehaviorRelay<[PokemonCollectionItem]>(value: [])
    private var startIndex = 0
    
    // MARK: -
    // MARK: Overrided functions
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.items.bind { [weak self] in
            guard let self else { return }
            if !$0.isEmpty {
                if let text = self.navigationItem.searchController?.searchBar.text, text.isEmpty {
                    self.startIndex = self.pokemonsToShow.value.count
                    var pokemons = [PokemonCollectionItem.startItem()]
                    pokemons += $0
                    self.downloadedPokemons = pokemons
                    self.pokemonsToShow.accept(pokemons)
                } else {
                    self.pokemonsToShow.accept($0)
                }
            }
        }
        .disposed(by: disposeBag)
        
        self.pokemonsToShow.bind { [weak self] in
            guard
                let self,
                let text = self.navigationItem.searchController?.searchBar.text
            else { return }
            
            if text.isEmpty {
                var indexPaths = [IndexPath]()
                if $0.count > self.startIndex {
                    indexPaths = Array(self.startIndex...($0.count - 1))
                        .map { return IndexPath(item: $0, section: 0) }
                    
                    self.collectionView?.performBatchUpdates {
                        self.collectionView?.insertItems(at: indexPaths)
                    }
                }
            } else {
                self.collectionView?.reloadData()
            }
        }
        .disposed(by: disposeBag)
        
        self.navigationItem.searchController?
            .searchBar.rx.text.debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind { [weak self] text in
                guard let text else { return }
                if !text.isEmpty {
                    self?.viewModel.searchOf(text: text)
                } else {
                    self?.startIndex = 0
                    self?.viewModel.offset = 0
                    self?.viewModel.items.accept([])
                    self?.viewModel.getNextPage()
                    //self?.viewModel.items.accept(Array(self?.downloadedPokemons.dropFirst() ?? []))
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func setup() {
        self.navigationBarSetup()
        self.navigationItemSetup()
        self.collectionSetup()
    }
    
    override func style() {
        self.view.backgroundColor = .wildSand
    }
    
    override func layout() {
        self.collectionViewLayout()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func navigationBarSetup() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = .abbey
        self.navigationController?.navigationBar.prefersLargeTitles = !(self.navigationItem.searchController?.isActive ?? false)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.plusJacartaSans(size: 34.0),
            NSAttributedString.Key.foregroundColor: UIColor.abbey
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.plusJacartaSans(size: 24.0),
            NSAttributedString.Key.foregroundColor: UIColor.abbey
        ]
    }
    
    private func navigationItemSetup() {
        self.navigationItem.title = "All pokemon"
        
        let searchController = UISearchController()
        searchController.searchBar.searchTextField.layer.cornerRadius = 18.0
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        searchController.searchBar.placeholder = "Name or number..."
        searchController.searchBar.barTintColor = .wildSand
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.backgroundColor = .wildSand
        searchController.searchBar.tintColor = .abbey
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = !searchController.isActive
        
        if let cancelButton = searchController.searchBar.value(forKey: "cancelButton") as? UIButton {
            let attributedString = NSAttributedString(
                string: "Cancel",
                attributes: [
                    .foregroundColor: UIColor.abbey,
                    .font: UIFont.plusJacartaSans(size: 15.0)
                ]
            )
            
            cancelButton.setTitleColor(.abbey, for: .normal)
            cancelButton.setAttributedTitle(attributedString, for: .normal)
        }
        
        let leftItem = UIBarButtonItem(
            image: UIImage(named: "logo24")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(self.leftAction)
        )
        
        let rightItem = UIBarButtonItem(
            image: UIImage(named: "collectionRepresentIcon"),
            style: .plain,
            target: self,
            action: #selector(self.rightAction)
        )
        
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func leftAction() {
        self.viewModel.handleAbout()
    }
    
    @objc private func rightAction() {
        self.switchCollectionLayout()
    }
    
    // MARK: -
    // MARK: Collection Layout
    
    private func collectionSetup() {
        self.collectionLayout = self.layoutMode.currentLayout
        self.collectionLayout?.delegate = self
        
        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.collectionLayout ?? UICollectionViewLayout()
        )
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.refreshControl = self.refreshControl
        
        self.collectionView?.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PokemonCollectionViewCell.self))
        self.collectionView?.backgroundColor = .wildSand
        self.view.addSubview(self.collectionView ?? UIView())
    }
    
    private func collectionViewLayout() {
        self.collectionView?.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func switchCollectionLayout() {
        guard let cells = self.collectionView?
            .visibleCells as? [PokemonCollectionViewCell] else { return }
        
        switch self.layoutMode {
        case .list:
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "tableRepresentIcon")
            self.layoutMode = .mosaic
        case .mosaic:
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "collectionRepresentIcon")
            self.layoutMode = .list
        }

        self.collectionLayout = self.layoutMode.currentLayout
        self.collectionLayout?.delegate = self
        self.collectionView?.setCollectionViewLayout(
            self.collectionLayout ?? UICollectionViewLayout(),
            animated: true
        )
        
        cells.forEach {
            $0.switchMode(to: layoutMode)
            $0.contentView.layoutIfNeeded()
        }
    }
    
    @objc private func refreshCollection(sender: UIRefreshControl) {
        self.startIndex = 0
        self.pokemonsToShow.accept([])
        self.viewModel.viewDidLoaded()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func requiredTextHeight(text: String , cellWidth : CGFloat) -> CGFloat {
        let font = UIFont.paytoneOneRegular(size: 22.0)
        let label = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: cellWidth,
                height: .greatestFiniteMagnitude
            )
        )
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}

extension DashboardView: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        if !searchText.isEmpty {
            searchBar.searchTextField.layer.borderWidth = 2.0
            searchBar.searchTextField.layer.borderColor = UIColor.gold.cgColor
        } else {
            searchBar.searchTextField.layer.borderWidth = 0.0
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.resignFirstResponder()
    }
}

extension DashboardView: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemonsToShow.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: PokemonCollectionViewCell.self),
            for: indexPath
        ) as? PokemonCollectionViewCell else { return UICollectionViewCell() }
        let model = self.pokemonsToShow.value[indexPath.item]
        cell.configure(with: model, index: indexPath.item)
        
        if self.collectionLayout is ListLayout {
            cell.switchMode(to: .list)
        } else {
            cell.switchMode(to: .mosaic)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.showDetailFor(item: self.pokemonsToShow.value[indexPath.item])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height)
            && scrollView.contentSize.height != 0
            && !self.viewModel.isLoadingList) {
            self.viewModel.isLoadingList = true
            self.viewModel.getNextPage()
        }
    }
}

extension DashboardView: MosaicLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        let model = self.pokemonsToShow.value[indexPath.item]
        var height = self.requiredTextHeight(
            text: model.name,
            cellWidth: itemWidth - (self.collectionLayout is ListLayout ? 16.0 * 3.0 + 95.0 : 9.0 + 16.0)
        )

        if self.collectionLayout is ListLayout {
            //height += CGFloat(2 * 12 + 23 + 15 + 2 * 16)
            height += 94.0
        } else {
            //height += CGFloat(8 + 15 + 95 + 4 + 12 + 23 + 16)
            height += 173.0
        }

        return height
    }
}
