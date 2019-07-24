//
//  TopMenuBar.swift
//  BOA Interview
//
//  Created by DLR on 7/22/19.
//  Copyright © 2019 DLR. All rights reserved.
//

import UIKit

protocol MenuBarDelegate {
    func menuDidTapped(at index: Int)
}

class TopMenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let menuCellId = "menuCellId"
    var delegate: MenuBarDelegate?
    private var titles = [String]()
    
    var numberOfItem: CGFloat {
        return CGFloat(titles.count == 0 ? 1 : titles.count)
    }
    
    var selectedIndex = 0
    var highlightColor: UIColor = .black
    var unhighlightColor: UIColor = .lightGray
    
    private lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: menuCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let bottomBarHeight: CGFloat = 2
    private var barLeadingConstraint: NSLayoutConstraint?
    private let bottomBar: UIView = {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    convenience init(titles: [String], highlightColor: UIColor = .black, unhighlightColor: UIColor = .lightGray) {
        self.init(frame: .zero)
        self.titles = titles
        self.highlightColor = highlightColor
        self.unhighlightColor = unhighlightColor
        setupView()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        addSubview(menuCollectionView)
        menuCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        menuCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        menuCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        menuCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(bottomBar)
        bottomBar.backgroundColor = highlightColor
        barLeadingConstraint = bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor)
        barLeadingConstraint?.isActive = true
        bottomBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / numberOfItem).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: bottomBarHeight).isActive = true
    }
    
    func scrollTo(offset: CGFloat) {
        selectedIndex = Int(round(offset))
        let barWidth = self.bounds.width / numberOfItem
        barLeadingConstraint?.constant = offset * barWidth
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        menuCollectionView.reloadData()
        reloadInputViews()
    }
    
    // MARK: - CollectionView DataSource / Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellId, for: indexPath) as! MenuCell
        setupCell(cell: cell, at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / CGFloat(titles.count), height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        delegate?.menuDidTapped(at: indexPath.item)
        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: { self.reloadInputViews()
        },completion: { _ in
            self.menuCollectionView.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    fileprivate func setupCell(cell: MenuCell, at indexPath: IndexPath) {
        let index = indexPath.item
        cell.titleLabel.text = self.titles[index]
        cell.titleLabel.textColor = index == selectedIndex ? highlightColor : unhighlightColor
    }
}
