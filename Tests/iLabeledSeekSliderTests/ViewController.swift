//
//  ViewController.swift
//  iLabeledSeekSliderTest
//
//  Created by Edgar Žigis on 2021-10-20.
//  Copyright © 2021 Edgar Žigis. All rights reserved.
//

import UIKit
import iLabeledSeekSlider

class ViewController: UIViewController {

    @IBOutlet weak var slider: iLabeledSeekSlider!
    @IBOutlet weak var versionWithoutStoryBoardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.onValueChanged = { value in
            print("Slider value: \(value)")
        }
    }
    
    @IBAction func onVersionWithoutStoryBoard(_ sender: Any) {
        present(ViewControllerWithoutStoryBoard(), animated: true, completion: nil)
    }
}
