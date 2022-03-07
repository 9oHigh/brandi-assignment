//
//  SearchViewModel.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/04.
//

final class SearchViewModel {
    
    private let service = Service()
    var errorMessage: Observable<String> = Observable("")
    var items = ImageModel(meta: nil, documents: nil)
    var overlap : String = ""
    var page: Int = 1
    
    func fetchImages(query: String, onCompletion: @escaping (ImageModel?,Bool?) -> Void){
        // overlap return
        if query == overlap { return }
        else { overlap = query }
        
        // 검색시 page 값을 1로 초기화 - New Query
        resetPage()
        
        let parm = SearchParameter(query: query, sortType: .accuracy, page: page, size: 30)
            
        service.fetchDatas(parm: parm) { [weak self] images, error in
            guard let images = images else {
                if let error = error {
                    self?.clearItems {}
                    if query != "" {
                        self?.errorMessage.value = error.description
                    }
                    onCompletion(nil,nil)
                }
                return
            }
            self?.items = images
            // isLast
            self?.items.meta.isEnd == false ? (self?.page += 1) : ()
            onCompletion(self?.items,self?.items.meta.isEnd)
        }
    }
    
    func addImages(onCompletion: @escaping (ImageModel?,Bool?)->Void){
        
        let parm = SearchParameter(query: overlap, sortType: .accuracy, page: page, size: 30)
        
        service.fetchDatas(parm: parm) { [weak self] images, error in
            guard let images = images else {
                if let error = error {
                    self?.errorMessage.value = error.description
                    onCompletion(nil,nil)
                }
                return
            }
            self?.items.meta = images.meta
            self?.items.documents += images.documents

            var isContinue : Bool
            self?.items.meta.isEnd == false ? (self?.page += 1) : ()
            // Max page
            isContinue = self?.page == 50 ? false : true
            // Or isLast
            isContinue = self!.items.meta.isEnd ? false : true
            onCompletion(self?.items,isContinue)
        }
    }
    
    func clearItems(onCompletion: @escaping() -> Void){
        items = ImageModel(meta: nil, documents: nil)
        resetPage()
//        errorMessage = Observable("")
//        fetchImages(query: "") { _,_ in }
        onCompletion()
    }
    
    func resetPage(){
        page = 1
    }
}

extension SearchViewModel {
    
    var numberOfItem : Int {
        return items.documents.count
    }
}
