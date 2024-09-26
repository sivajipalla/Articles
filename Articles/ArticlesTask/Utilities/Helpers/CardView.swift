//
//  CardView.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import Foundation
import UIKit

@IBDesignable
class CardView: UIView {

    // Inspectable properties for Interface Builder
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.1 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 2) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 4 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCardView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCardView()
    }
    
    private func setupCardView() {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
}
