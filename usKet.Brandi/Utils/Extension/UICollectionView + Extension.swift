//
//  UICollectionView + Extension.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/04.
//

import UIKit

extension UICollectionView {
    
    var interval: CGFloat {
        return 8
    }
    
    var originSize: CGFloat {
        return bounds.width
    }
    
    var numberOfEachRow: CGFloat {
        return 3
    }
    
    var preferredCellSize: CGSize {
        let cellSize = (originSize - interval * (numberOfEachRow + 1)) / numberOfEachRow
        return CGSize(width: cellSize, height: cellSize)
    }
}
