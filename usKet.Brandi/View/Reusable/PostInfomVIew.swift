//
//  PostInfomVIew.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/06.
//

import UIKit

final class PostInformView: UIView {
    
    let siteLabel = Utility.configureInformLabel()
    let dateLabel = Utility.configureInformLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(siteLabel)
        addSubview(dateLabel)
        
        siteLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(siteLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
