//
//  ImageCollectionFooterView.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/05.
//

import UIKit

final class ImageCollectionFooterView : UICollectionReusableView {
    
    let indicator = UIActivityIndicatorView(style: .medium )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
