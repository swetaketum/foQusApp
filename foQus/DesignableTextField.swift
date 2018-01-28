//
//  DesignableTextField.swift
//  foQus
//
//  Created by akhila on 28.01.18.
//  Copyright © 2018 Optys Tech Corporation. All rights reserved.
//

import UIKit
@IBDesignable
class DesignableTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var leftImage: UIImage?{
        didSet {
            updateView()
        }
    }
        func updateView(){
            if let image = leftImage{
                leftViewMode = .always
                let imageView = UIImageView(frame: CGRect (x: 0, y: 0, width: 20, height: 20))
                imageView.image = image
                
                leftView = imageView
            }
            else{
                leftViewMode = .never
            }
        }
    

}
