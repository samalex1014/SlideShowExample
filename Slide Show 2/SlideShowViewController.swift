//
//  SlideShowViewController.swift
//  Slide Show 2
//
//  Created by Smith, Sam on 1/15/19.
//  Copyright © 2019 Smith, Sam. All rights reserved.
//

import UIKit

class SlideShowViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func previousButtonPressed(_ sender: Any) {
        if imageView.image == UIImage(named: "image1") {
            imageView.image = UIImage(named: "image3")
        } else if imageView.image == UIImage(named: "image2") {
            imageView.image = UIImage(named: "image1")
        } else {
            imageView.image = UIImage(named: "image2")
        }
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        if imageView.image == UIImage(named: "image1") {
            imageView.image = UIImage(named: "image2")
        } else if imageView.image == UIImage(named: "image2") {
            imageView.image = UIImage(named: "image3")
        } else {
            imageView.image = UIImage(named: "image1")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ARMove", let dest = segue.destination as? ARViewController else { return }
        
        dest.image = imageView.image!
    }
    
}
