//
//  ViewControllerWithoutStoryBoard.swift
//  iLabeledSeekSliderTest
//
//  Created by Edgar Žigis on 2021-10-20.
//  Copyright © 2021 Edgar Žigis. All rights reserved.
//

import UIKit
import iLabeledSeekSlider

class ViewControllerWithoutStoryBoard: UIViewController {
    
    let slider = iLabeledSeekSlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.width
        
        applyStyle(to: slider)
        slider.frame = CGRect(x: width * 0.05, y: 150, width: width * 0.9, height: 100)
        view.addSubview(slider)
        
        view.backgroundColor = .white
    }
    
    private func applyStyle(to v: iLabeledSeekSlider) {
        v.title = "Amount"
        v.unit = "€"
        v.minValue = 100
        v.maxValue = 1000
        v.defaultValue = 550
    }
}
