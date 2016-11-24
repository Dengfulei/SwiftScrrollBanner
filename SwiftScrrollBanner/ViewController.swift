//
//  ViewController.swift
//  SwiftScrrollBanner
//
//  Created by 杭州移领 on 16/11/22.
//  Copyright © 2016年 DFL. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, DFLBannerViewDelegate {

    var images = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let  banner = DFLBannerView(frame:CGRect(x:0,y:100,width:self.view.frame.width,height:200))
        banner.delegate = self;
//        banner.backgroundColor = UIColor.red
        self.view.addSubview(banner)
        for i in 0..<3 {
            let  name = "\(i).jpg"
            let image = UIImage.init(named: name)
            images.add(image)
            
        }
        banner.currentImageIndex = 1
        banner.images = images
        
    }

    func bannerViewDidClickImageView(index: NSInteger) {
        print("\(index)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

