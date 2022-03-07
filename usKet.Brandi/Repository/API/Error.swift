//
//  APIError.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/04.
//

import Foundation

protocol DescriptionError {
    var description: String { get }
}

enum APIError: Int, DescriptionError {
    
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case requestTimeout = 408
    case tooManyRequest = 429
    case serverError = 500
    case serverUnavalable = 503
    case serverTimeout = 504
    case unownedError = 0
    
    init(rawValue: Int) {
        switch rawValue {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 408:
            self = .requestTimeout
        case 429:
            self = .tooManyRequest
        case 500:
            self = .serverError
        case 503:
            self = .serverUnavalable
        case 504:
            self = .serverTimeout
        default:
            self = .unownedError
        }
    }
    
    var description: String {
        switch self {
            
        case .badRequest:
            return "검색할 수 없는 단어입니다."
        case .unauthorized:
            return "인증되지 않았습니다"
        case .forbidden:
            return "서버로부터 요청이 거절되었습니다"
        case .notFound:
            return "요청받은 리소스를 찾을 수 없습니다"
        case .requestTimeout:
            return "요청시간을 초과했습니다"
        case .tooManyRequest:
            return "너무 많은 요청으로 인해 오류가 발생했습니다"
        case .serverError:
            return "검색할 수 없는 단어입니다."
        case .serverUnavalable:
            return "아직 사용할 수 없는 서버입니다"
        case .serverTimeout:
            return "현재 서버가 응답을 받을 수 없습니다"
        case .unownedError:
            return "알 수 없는 오류가 발생했습니다. "
        }
    }
}
