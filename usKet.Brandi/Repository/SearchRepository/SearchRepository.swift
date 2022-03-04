//
//  SearchRepository.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/05.
//

import Moya

final class SearchRepository {
    
    private let provider = MoyaProvider<SearchTarget>()
    
    func fetchSources(apiKey: String, query: String, sortType: ResultSortType, page: Int, size: Int, onCompletion: @escaping (Source?,APIError?) -> Void){
        
        let parm = SearchParameter(query: query, sortType: sortType, page: page, size: size)
        
        provider.request(.requestSource(apiKey: apiKey, parm: parm)){ result in
            switch result {
            case .success(let response):
                onCompletion(try? response.map(Source.self), nil)
            case .failure(let error):
                let apiError = APIError(rawValue: error.response?.statusCode ?? 0)
                onCompletion(nil,apiError)
            }
        }
    }
}
