//
//  BorderedButton.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 27/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {

    override func draw(_ rect: CGRect) {
        layer.borderWidth = 2.0
        layer.borderColor = UIColor(named: "CustomYellow")!.cgColor
        layer.cornerRadius = 20.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    }

}
