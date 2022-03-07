//
//  UIView + Extension.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/07.
//

import UIKit

extension UIView {
    
    func setShadow() {
        //Shadow
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.5
    }
}
