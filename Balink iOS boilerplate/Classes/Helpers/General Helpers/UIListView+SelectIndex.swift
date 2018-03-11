//
//  UIListView+SelectIndex.swift
//  Berluti
//
//  Created by elie buff on 28/12/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    public func selectIndex(indexPath : IndexPath) {
        if self.isValidIndexPath(indexPath: indexPath){
            self.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            self.delegate?.tableView!(self, didSelectRowAt: indexPath)
        }
    }
    
    public func deselectIndex(indexPath : IndexPath) {
        if self.isValidIndexPath(indexPath: indexPath){
            self.deselectRow(at: indexPath, animated: true)
            self.delegate?.tableView!(self, didDeselectRowAt: indexPath)
        }
    }
    
    public func isValidIndexPath(indexPath : IndexPath) -> Bool{
        return indexPath.section <= self.numberOfSections && indexPath.row <= self.numberOfRows(inSection: indexPath.section)
    }
}
