//
//  Meta.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/05.
//

// MARK: - Meta

struct Meta: Codable {
    let totalCount, pageableCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}
