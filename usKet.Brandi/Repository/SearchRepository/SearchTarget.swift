//
//  SearchTarget.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/05.
//

import Moya

enum ResultSortType : String {
    case accuracy
    case recency
}

extension ResultSortType {
    var sortType : String {
        return rawValue
    }
}

enum SearchTarget {
    case requestSource(apiKey: String, parm: SearchParameter)
}

extension SearchTarget : TargetType {
    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com")!
    }
    
    var path: String {
        switch self {
        case .requestSource:
            return "v2/search/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestSource:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .requestSource(_, let parm):
            return .requestParameters(parameters: [
                "query": parm.query,
                "sort": parm.sortType.rawValue,
                "page": parm.page,
                "size": parm.size
            ], encoding: URLEncoding(arrayEncoding: .noBrackets))
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .requestSource(let apiKey,_):
            return [
                "Authorization": "KakaoAK \(apiKey)",
                "Content-Type": "application/json;charset=UTF-8"
            ]
        }
    }
}
