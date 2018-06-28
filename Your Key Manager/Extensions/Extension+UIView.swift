//
//  Extension+UIView.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 27/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
