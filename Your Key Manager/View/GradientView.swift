//
//  Extension_UIView.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 27/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import UIKit

class GradientView: UIView {
    @IBInspectable var colorOne: UIColor = UIColor.white
    @IBInspectable var colorTwo: UIColor = UIColor.black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [colorOne.cgColor, colorTwo.cgColor]
    }
}

