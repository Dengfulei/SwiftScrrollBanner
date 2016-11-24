//
//  DFLBannerView.swift
//  SwiftScrrollBanner
//
//  Created by 杭州移领 on 16/11/22.
//  Copyright © 2016年 DFL. All rights reserved.
//

import UIKit
protocol DFLBannerViewDelegate {
    
    func bannerViewDidClickImageView(index:NSInteger)
}
/**枚举类型*/
enum DFLBannerScrollType {
    case scrollTypeStatic, // 非滑动状态
         scrollTypeLeft,
         scrollTypeRight
}

class DFLBannerView: UIView ,UIScrollViewDelegate{
    
    private var scrollView          : UIScrollView!
    private var pageControl         : UIPageControl!
    private var displayImageView    : UIImageView!
    private var resueImageView      : UIImageView!
    private var scrollType          :DFLBannerScrollType!
    var delegate                    : DFLBannerViewDelegate!
    var currentImageIndex           : NSInteger!
    var images = NSArray() {
        didSet {
          self.loadDisplayImageView()
        }
    }
    
    
    
    func loadDisplayImageView() {
        for subView  in displayImageView.subviews {
            subView.removeFromSuperview()
        }
        if images.count > 0 {
            displayImageView.image = images[self.currentImageIndex] as? UIImage
        }
        scrollView.setContentOffset(CGPoint(x:self.frame.width,y:0), animated: false)
        scrollView.isScrollEnabled = images.count > 1 ? true:false
        
    }
    
    func loadResueImageView() -> Void {
        
        for subView in displayImageView.subviews {
            subView.removeFromSuperview()
        }
        var  frame = resueImageView.frame;
        var resueIndex = self.currentImageIndex
        if scrollType == DFLBannerScrollType.scrollTypeLeft {
            frame.origin.x = 0;
            resueIndex = self.formatIndexWithIndex(idx: resueIndex! - 1)
        } else {
            frame.origin.x = self.scrollView.frame.size.width * 2;
            resueIndex = self.formatIndexWithIndex(idx: resueIndex! + 1);
        }
        resueImageView.image = self.images[resueIndex!] as? UIImage
        resueImageView.frame = frame
        
    }
    
    private func formatIndexWithIndex(idx:NSInteger) -> NSInteger{
        var resultidx = idx
        if resultidx < 0 {
            resultidx = self.images.count - 1
        } else if resultidx == self.images.count {
            resultidx = 0
        }
        return resultidx
    }
    
    private func updateCurrentIndex() {
        if (scrollType == DFLBannerScrollType.scrollTypeLeft) {
           self.currentImageIndex = self.formatIndexWithIndex(idx: self.currentImageIndex - 1)
        } else {
           self.currentImageIndex = self.formatIndexWithIndex(idx: self.currentImageIndex + 1)
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.yellow
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        self.addSubview(scrollView)
            
        displayImageView = UIImageView()
        displayImageView.isUserInteractionEnabled = true
        displayImageView.backgroundColor = UIColor.red
        scrollView.addSubview(displayImageView)
        
        resueImageView = UIImageView()
        resueImageView.backgroundColor = UIColor.green
        resueImageView.isUserInteractionEnabled = true
        scrollView.addSubview(resueImageView)
        
        scrollView.contentSize = CGSize(width:3 * self.bounds.width,height:0)
        scrollView.frame = CGRect(x:0,y:0,width:self.bounds.width,height:self.bounds.height)
        displayImageView.frame = CGRect(x:self.frame.width,y:0,width:self.frame.width,height:self.bounds.height)
        resueImageView.frame = CGRect(x:0,y:0,width:self.bounds.width,height:self.bounds.height)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickImageView(gesture:)))
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(clickImageView(gesture:)))
        displayImageView.addGestureRecognizer(gesture)
        resueImageView.addGestureRecognizer(gesture1)
  
    }
    func clickImageView(gesture:UITapGestureRecognizer) {
        
        delegate.bannerViewDidClickImageView(index: self.currentImageIndex)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func isInScreen(frame:CGRect) ->Bool {
        
        return (frame.maxX > scrollView.contentOffset.x) &&
            (frame.minX < scrollView.contentOffset.x + scrollView.frame.size.width);
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
       let  cosX = scrollView.contentOffset.x;
        // 当显示页面消失在屏幕时立刻更新Display Image
        if !self.isInScreen(frame: displayImageView.frame)  {
            // 更新Current Index
            self.updateCurrentIndex()
            // 还原滚动方向
            self.scrollType = DFLBannerScrollType.scrollTypeStatic;
            // 更新Display view
            self.loadDisplayImageView()
            
            // 判断滚动方向
        } else if cosX > self.frame.size.width {
            // 右
            if (self.scrollType != DFLBannerScrollType.scrollTypeRight) {
                self.scrollType = DFLBannerScrollType.scrollTypeRight;
                self.loadResueImageView()
            }
        } else {
            // 左
            if (self.scrollType != DFLBannerScrollType.scrollTypeLeft) {
                self.scrollType = DFLBannerScrollType.scrollTypeLeft;
               self.loadResueImageView()
            }
        }

    }
 
}
