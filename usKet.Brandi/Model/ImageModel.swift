//
//  ImageModel.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/05.
//

struct ImageModel {
    var meta: Meta
    var documents: [Document]
    
    init(meta: Meta?, documents: [Document]?) {
        self.meta = meta ?? Meta(totalCount: 0, pageableCount: 0, isEnd: true)
        self.documents = documents ?? [Document(collection: "", thumbnailURL: "", imageURL: "", width: 0, height: 0, displaySitename: "", docURL: "", datetime: "")]
    }
}
