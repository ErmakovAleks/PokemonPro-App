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


final class DashboardView: BaseView<DashboardViewModel, DashboardOutputEvents> {

    // MARK: -
    // MARK: Variables
    
    private let titleContainerView = UIView()
    private let searchBarContainerView = UIView()
    private let titleLabel = UILabel()
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView?
    private var collectionLayout: ItemHeightDelegateContainable?
    
    // MARK: -
    // MARK: Overrided functions
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.items.bind { [weak self] _ in
            self?.collectionView?.reloadData()
        }
        .disposed(by: disposeBag)
    }
    
    override func setup() {
        self.navigationBarSetup()
        self.navigationItemSetup()
        self.containersSetup()
        self.customNavigationBarSearchBarSetup()
        self.collectionSetup()
    }
    
    override func style() {
        self.view.backgroundColor = .wildSand
        self.customNavigationBarTitleStyle()
        self.customNavigationBarSearchBarStyle()
    }
    
    override func layout() {
        self.containersLayout()
        self.customNavigationBarTitleLayout()
        self.customNavigationBarSearchBarLayout()
        self.collectionViewLayout()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func navigationBarSetup() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = .abbey
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.plusJacartaSans(size: 24.0),
            NSAttributedString.Key.foregroundColor: UIColor.abbey
        ]
    }
    
    private func navigationItemSetup() {
        self.navigationItem.title = "All pokemon"
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
        self.collectionLayout = ListLayout(cellPadding: 16.0)
        self.collectionLayout?.delegate = self
        
        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.collectionLayout ?? UICollectionViewLayout()
        )
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.collectionView?.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PokemonCollectionViewCell.self))
        self.collectionView?.backgroundColor = .wildSand
        self.view.addSubview(self.collectionView ?? UIView())
    }
    
    private func collectionViewLayout() {
        self.collectionView?.snp.makeConstraints {
            $0.top.equalTo(self.searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func switchCollectionLayout() {
        guard let cells = self.collectionView?
            .visibleCells as? [PokemonCollectionViewCell] else { return }
        
        var layoutMode: RepresentMode
        
        if self.collectionLayout is ListLayout {
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "tableRepresentIcon")
            self.collectionLayout = MosaicLayout(cellPadding: 9.0)
            layoutMode = .mosaic
        } else {
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "collectionRepresentIcon")
            self.collectionLayout = ListLayout(cellPadding: 16.0)
            layoutMode = .list
        }
        
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
    
    // MARK: -
    // MARK: Containers preparing
    
    private func containersSetup() {
        self.view.addSubview(self.titleContainerView)
        self.titleContainerView.addSubview(self.titleLabel)
        
        self.view.addSubview(self.searchBarContainerView)
        self.searchBarContainerView.addSubview(self.searchBar)
    }
    
    private func containersLayout() {
        self.titleContainerView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(68.0)
        }
        
        self.searchBarContainerView.snp.makeConstraints {
            $0.top.equalTo(self.titleContainerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40.0)
        }
    }
    
    // MARK: -
    // MARK: Custom NavigationBar Title preparing
    
    private func customNavigationBarTitleStyle() {
        self.titleLabel.text = "All pokemon"
        self.titleLabel.font = .plusJacartaSans(size: 34.0)
        self.titleLabel.textColor = .abbey
        self.titleLabel.sizeToFit()
    }
    
    private func customNavigationBarTitleLayout() {
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.equalToSuperview().inset(30.0)
        }
    }
    
    // MARK: -
    // MARK: Custom NavigationBar SearchBar preparing
    
    private func customNavigationBarSearchBarSetup() {
        self.searchBar.delegate = self
    }
    
    private func customNavigationBarSearchBarStyle() {
        self.searchBar.searchTextField.layer.cornerRadius = 18.0
        self.searchBar.searchTextField.layer.masksToBounds = true
        self.searchBar.placeholder = "Name or number..."
        self.searchBar.barTintColor = .wildSand
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.backgroundColor = .wildSand
        self.searchBar.tintColor = .abbey
        
        if let cancelButton = self.searchBar.value(forKey: "cancelButton") as? UIButton {
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
    }
    
    private func customNavigationBarSearchBarLayout() {
        self.searchBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func showCustomNavigationBar() {
        UIView.animate(withDuration: Constants.animationTime) {
            self.titleLabel.alpha = 1.0
            self.titleContainerView.snp.remakeConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide)
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(68.0)
            }
            
            self.titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(20.0)
                $0.leading.equalToSuperview().inset(30.0)
            }
            
            self.searchBarContainerView.snp.remakeConstraints {
                $0.top.equalTo(self.titleContainerView.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(40.0)
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideCustomNavigationBar() {
        UIView.animate(withDuration: Constants.alphaAnimationTime) {
            self.titleLabel.alpha = 0.0
        }
        
        UIView.animate(withDuration: Constants.animationTime) {
            self.titleContainerView.snp.remakeConstraints {
                $0.height.equalTo(0.0)
            }
            
            self.titleLabel.snp.makeConstraints {
                $0.height.equalTo(0.0)
            }
            
            self.searchBarContainerView.snp.remakeConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide)
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(40.0)
            }
            
            self.view.layoutIfNeeded()
        }
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
        self.searchBar.setShowsCancelButton(true, animated: true)
        self.hideCustomNavigationBar()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar.setShowsCancelButton(true, animated: true)
        if !searchText.isEmpty {
            self.searchBar.searchTextField.layer.borderWidth = 2.0
            self.searchBar.searchTextField.layer.borderColor = UIColor.gold.cgColor
        } else {
            self.searchBar.searchTextField.layer.borderWidth = 0.0
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.showCustomNavigationBar()
        self.searchBar.resignFirstResponder()
    }
}

extension DashboardView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewModel.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: PokemonCollectionViewCell.self),
            for: indexPath
        ) as? PokemonCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: self.viewModel.items.value[indexPath.item], index: indexPath.item)
        
        if self.collectionLayout is ListLayout {
            cell.switchMode(to: .list)
        } else {
            cell.switchMode(to: .mosaic)
        }
        
        return cell
    }
}

extension DashboardView: MosaicLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        var height = self.requiredTextHeight(
            text: self.viewModel.items.value[indexPath.item].name,
            cellWidth: itemWidth - (self.collectionLayout is ListLayout ? 16.0 * 3.0 + 95.0 : 9.0 + 16.0)
        )
        
        if self.collectionLayout is ListLayout {
            height += CGFloat(2 * 12 + 23 + 15 + 2 * 16)
        } else {
            height += CGFloat(8 + 15 + 95 + 4 + 12 + 23 + 16)
        }
        
        return height
    }
}
