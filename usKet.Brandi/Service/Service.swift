//
//  Service.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/05.
//

final class Service {
    
    private let apiKey = "b43117bae6f844401d84e0da8e7b66be"
    private let repository = SearchRepository()
    private var model = ImageModel(meta: nil, documents: nil)
    
    func fetchDatas(parm: SearchParameter, onCompletion: @escaping (ImageModel?,APIError?) -> Void){
        repository.fetchSources(apiKey: apiKey, parm: parm) { [weak self] source, error in

            guard let source = source else {
                onCompletion(nil,error)
                return
            }
            self?.model.meta = source.meta
            self?.model.documents = source.documents
            onCompletion(self?.model,nil)
        }
    }
}
