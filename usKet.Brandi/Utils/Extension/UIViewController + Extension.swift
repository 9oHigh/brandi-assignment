//
//  UIViewController + Extension.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/05.
//

import UIKit
import Network

extension UIViewController {
    
    func monitorNetwork() {
        
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.showToast(message: "네트워크 연결 상태를 확인해주세요")
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
    func showToast(message: String, width: CGFloat = UIScreen.main.bounds.width * 0.8, height: CGFloat = 50, yPosition: CGFloat = 150) {
        
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - width/2, y: yPosition, width: width, height: height))
        
        toastLabel.backgroundColor = .black
        toastLabel.textColor = .white
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.5
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: {
            toastLabel.alpha = 0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
    
    func getNavigationBarHeight() -> CGFloat? {
        return self.navigationController?.navigationBar.frame.maxY
    }
}

