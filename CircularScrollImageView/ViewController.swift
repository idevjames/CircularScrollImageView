//
//  ViewController.swift
//  CircularScrollImageView
//
//  Created by HooGi on 2021/09/15.
//

import UIKit

class ViewController: UIViewController {
    
    private var scrollImageView: ScrollImageView!
    
    let images:[String] = [
        "image_0001",
        "image_0002",
        "image_0003",
        "image_0004",
        "image_0005"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .green
        
        makeScrollImageView()
    }
    
    
    //
    // MARK: If you want to use ScrollImageView, only call this function
    //
    private func makeScrollImageView() {
        scrollImageView = ScrollImageView(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 300))
        self.view.addSubview(scrollImageView)
        
        let samples: [UIImage] = images.map { UIImage(named: $0)! }
        var configuration = ScrollImageViewConfiguration()
        configuration.contentMode = .scaleAspectFit
        
        scrollImageView.reloadData(samples, configuration: configuration)
        
        scrollImageView.onClickImageHandler = { index in
            print("Selected Index is : \(index)")
        }
    }
}
