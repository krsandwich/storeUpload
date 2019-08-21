//
//  AltBGView.swift
//  StoreUpload
//
//  Created by Jeremy Ephron on 3/30/19.
//  Copyright © 2019 Kylee Krzanich. All rights reserved.
//

import UIKit

class AltBGView: UIViewController {
    let child = SpinnerViewController()
    
    override func viewDidLoad() {
        // BG Gradient
        let gradientLayer = CAGradientLayer();
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.white.cgColor,
                                UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor]
        // gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Footer
        let footer = UILabel(frame: CGRect(x: 0, y: self.view.frame.height * 0.935, width: self.view.frame.width, height: 50.0))
        footer.text = "© Stanford 2019 | Kylee Krzanich"
        footer.font = UIFont(name: "SFCompactRounded-Ultralight", size: 17.0)
        footer.textAlignment = NSTextAlignment.center
        footer.textColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0)
        self.view.addSubview(footer)
        
        super.viewDidLoad()
    }
    
    func createSpinnerView() {
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

    }
    func removeSpinnerView() {
        
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
    }
}
