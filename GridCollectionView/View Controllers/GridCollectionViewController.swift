//
//  CollectionViewController.swift
//  GridCollectionView
//
//  Created by Milos Grujic on 7.7.22..
//

import UIKit


class GridCollectionViewController: UICollectionViewController {

  
    let item = ItemModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
  
    func setupCollectionView() {
        
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(88)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
    }
  
}

extension GridCollectionViewController {
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        cell.inputTextView.text = item.items[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
}

extension GridCollectionViewController: GridCellDelegate {
   
    
    func textViewDidPinch(cellHeight: CGFloat) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func textViewDidChangeText(newText: String, requiresResize: Bool) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
