//
//  SearchViewModel.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/04.
//

import Foundation

final class SearchViewModel {
    
    private let service = Service()
    
    let items: Observable<ImageModel> = Observable(ImageModel(meta: nil, documents: nil))
    let query: Observable<String> = Observable("")
    let page: Observable<Int> = Observable(30)
    let errorMessage: Observable<String> = Observable("")
    
    func fetchImages(onCompletion: @escaping () -> Void){
        let parm = SearchParameter(query: query.value, sortType: .accuracy, page: page.value, size: 30)
        service.fetchDatas(parm: parm) { [weak self] images, error in
            
            guard let error = error else {
                return
            }
            self?.errorMessage.value = error.description
            
            guard let images = images else {
                return
            }
            self?.items.value = images
            
        }
    }
}

extension SearchViewModel {
    
    var numberOfItem : Int {
        return items.value.documents.count
    }
}
