//
//  Utils.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/04.
//

import UIKit

final class Utility {
    
    static func configureSearchController() -> UISearchController {
        
        let searchController = UISearchController()
        searchController.searchBar.tintColor = .black
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .black
        searchController.searchBar.placeholder = "검색어를 입력해주세요"
        return searchController
    }
    
    static func configureCollectionView() -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.keyboardDismissMode = .onDrag
        
        return collectionView
    }
    
    static func configureScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    static func configureImageView() -> UIImageView {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    static func configureInformLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }
    
    static func prettierDate(_ date: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let origin: Date = dateFormatter.date(from: date) ?? Date()
        
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let value = dateFormatter.string(from: origin)

        return value
    }
}
