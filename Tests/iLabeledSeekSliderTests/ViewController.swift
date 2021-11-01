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

    @IBOutlet weak var versionWithoutStoryBoardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.present(ViewControllerWithoutStoryBoard(), animated: true, completion: nil)
        })
    }
    
    @IBAction func onVersionWithoutStoryBoard(_ sender: Any) {
        present(ViewControllerWithoutStoryBoard(), animated: true, completion: nil)
    }
}
