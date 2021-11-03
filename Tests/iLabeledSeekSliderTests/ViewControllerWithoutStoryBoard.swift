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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slider = iLabeledSeekSlider()
        
        applyStyle(to: slider)
        view.addSubview(slider)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        slider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        view.backgroundColor = .white
    }
    
    private func applyStyle(to v: iLabeledSeekSlider) {
        v.title = "Amount"
        v.unit = "€"
        v.unitPosition = .back
        v.limitValueIndicator = "Max"
        v.minValue = 100
        v.maxValue = 1000
        v.defaultValue = 550
        v.limitValue = 850
        v.slidingInterval = 50
        v.valuesToSkip = [300, 350]
        v.trackHeight = 4
        v.activeTrackColor = UIColor(red: 1.0, green: 0.14, blue: 0.0, alpha: 1.0)
        v.inactiveTrackColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
        v.thumbSliderRadius = 12
        v.thumbSliderBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        v.rangeValueTextFont = UIFont.systemFont(ofSize: 12)
        v.rangeValueTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        v.titleTextFont = UIFont.systemFont(ofSize: 12)
        v.titleTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
        v.bubbleStrokeWidth = 2
        v.bubbleCornerRadius = 5
        v.bubbleValueTextFont = UIFont.boldSystemFont(ofSize: 12)
        v.bubbleOutlineColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
        v.bubbleValueTextColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
        v.vibrateOnLimitReached = true
        v.allowLimitValueBypass = false
        v.isDisabled = false
    }
}
