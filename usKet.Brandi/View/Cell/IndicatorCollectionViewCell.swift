//
//  IndicatorCollectionViewCell.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/05.
//

import UIKit

final class IndicatorCollectionViewCell : UICollectionViewCell {
    
    let indicatorView = UIActivityIndicatorView(style: .medium)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
