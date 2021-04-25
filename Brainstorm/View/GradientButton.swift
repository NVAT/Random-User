//
//  GradientButton.swift
//  Brainstorm

import UIKit

class GradientButton: UIButton {
    
    internal var isDisabled:Bool = false {
        didSet{
            update()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        update()
    }
    
    private func update() {
        
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        self.setTitleColor(isDisabled ? .black : .white, for: .normal)
        let layer = CAGradientLayer()
        layer.frame = self.frame
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        if isDisabled {
            layer.colors = [UIColor.lightGray.withAlphaComponent(0.2).cgColor, UIColor.lightGray.withAlphaComponent(0.4).cgColor]
            self.setTitle("User saved", for: .normal)
        }else{
            layer.colors = [UIColor.green.withAlphaComponent(0.4).cgColor, UIColor.green.cgColor]
        }
        self.isEnabled = !isDisabled
        self.layer.insertSublayer(layer, at: 0)
    }
    
}


class ProfileImage:UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
    }
    
}
