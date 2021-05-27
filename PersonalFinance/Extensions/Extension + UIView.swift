//
//  UIVIew+Extension.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 24.05.21.
//

import UIKit

extension UIView {
    func roundCorners(radius: CGFloat? = 10) {
        guard let radius = radius else {
            return
        }
        layer.cornerRadius = radius
    }
    
    func dropShadow(shadowColor: UIColor? = .black) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor ?? UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addGradient(startPointColor: UIColor, endPointColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [startPointColor.cgColor, endPointColor.cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
}
