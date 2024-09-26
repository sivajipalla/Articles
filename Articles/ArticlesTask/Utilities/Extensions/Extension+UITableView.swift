//
//  Extension+UITableView.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier:String {
        return String(describing:self)
    }
    
    static var nib:UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
