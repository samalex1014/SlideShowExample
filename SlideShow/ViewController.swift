//
//  ViewController.swift
//  SlideShow
//
//  Created by Smith, Sam on 12/21/18.
//  Copyright © 2018 Smith, Sam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var image1 = UIImage(named: "Image1")
    var image2 = UIImage(named: "Image2")
    var image3 = UIImage(named: "Image3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        if imageView.image == image1 {
            imageView.image = image2
        } else if imageView.image == image2 {
            imageView.image = image3
        } else {
            imageView.image = image1
        }
    }
    
}

