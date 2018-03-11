//
//  UICollectionView + SelectIndex.swift
//  Berluti
//
//  Created by elie buff on 07/01/2018.
//  Copyright © 2018 elie buff. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {
    public func selectIndex(indexPath : IndexPath) {
        if self.isValidIndexPath(indexPath: indexPath){
            self.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
            self.delegate?.collectionView!(self, didSelectItemAt: indexPath)
        }
    }
    
    public func deselectIndex(indexPath : IndexPath) {
        if self.isValidIndexPath(indexPath: indexPath){
            self.deselectItem(at: indexPath, animated: true)
        }
    }
    
    public func isValidIndexPath(indexPath : IndexPath) -> Bool{
        return indexPath.section <= self.numberOfSections && indexPath.row <= self.numberOfItems(inSection: indexPath.section)
    }
}

