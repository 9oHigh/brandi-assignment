//
//  InformView.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/05.
//

import UIKit

final class InformView : UIView {
    
    let informLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(informLabel)
        informLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInformText(message: String){
        informLabel.text = message
    }
}

