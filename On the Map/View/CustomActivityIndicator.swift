//
//  CustomActivityIndicator.swift
//  On the Map
//
//  Created by António Ramos on 01/07/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

class MyIndicator: UIView {
    
    let mainImageView = UIImageView()
    let maskImageView = UIImageView()
    
    init(frame: CGRect, image: UIImage, imageMask: UIImage) {
        super.init(frame: frame)
        
        setProperties(imageView: mainImageView, image: image)
        setProperties(imageView: maskImageView, image: imageMask)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func startAnimating() {
        isHidden = false
        rotate()
    }
    
    func stopAnimating() {
        isHidden = true
        removeRotation()
    }
    
    private func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.maskImageView.layer.add(rotation, forKey: "rotationAnimation")
     
    }
    
    
    private func removeRotation() {
        self.mainImageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    private func setProperties(imageView:UIImageView, image: UIImage) {
        imageView.frame = bounds
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
    }
}
