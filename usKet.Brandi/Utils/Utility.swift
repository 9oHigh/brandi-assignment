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
}
