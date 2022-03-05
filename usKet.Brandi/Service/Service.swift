//
//  Service.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/05.
//

final class Service {
    
    private let repository = SearchRepository()
    static let apiKey = ""
    private var model = ImageModel(meta: nil, documents: nil)
    
    func fetchDatas(parm: SearchParameter, onCompletion: @escaping (ImageModel?,APIError?) -> Void){
        repository.fetchSources(apiKey: Service.apiKey, parm: parm) { [weak self] source, error in
            
            guard let error = error else {
                return
            }
            onCompletion(nil,error)
            
            guard let source = source else {
                return
            }
            
            self?.model.meta = source.meta
            self?.model.documents = source.documents
            onCompletion(self?.model,nil)
        }
    }
}
