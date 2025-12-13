//
//  Extensions.swift
//  PetPlanner
//
//  Created by Tristan Katwaroo on 2025-12-07.
//

import UIKit

extension UIView {
    func applyShadow(color: UIColor = .black, opacity: Float = 0.2, x: CGFloat = 0, y: CGFloat = 4, blur: CGFloat = 6) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = blur
        self.layer.masksToBounds = false
    }
    
    func makeRound(radius: CGFloat = 12) {
        self.layer.cornerRadius = radius
    }
}

extension UITextField {
    func styleInput() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
