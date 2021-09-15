//
//  ScrollImageView.swift
//  CircularScrollImageView
//
//  Created by HooGi on 2021/09/15.
//

import UIKit

struct ScrollImageViewConfiguration {
    var usePageControl: Bool = true
    var contentMode: UIView.ContentMode = .scaleAspectFit
}

class ScrollImageView: UIView {
    // MARK:- Closure
    var onClickImageHandler: ((_ selectedIndex: Int) -> Void)?
    
    // MARK:- UI Components

    private let scrollView: UIScrollView = {
        let sc = UIScrollView(frame: .zero)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.isPagingEnabled = true
        sc.isUserInteractionEnabled = true
//        sc.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickScrollView(_:))))
        
        return sc
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl(frame: .zero)
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.isUserInteractionEnabled = false
        pc.pageIndicatorTintColor = UIColor.blue.withAlphaComponent(0.1)
        pc.currentPageIndicatorTintColor = .white
        
        return pc
    }()
    
    // MARK:- Variables
    private var images: [UIImage]?
    private var config = ScrollImageViewConfiguration()
    
    
    // MARK:- Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        scrollView.frame = self.bounds
        scrollView.delegate = self
        
        self.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickScrollView(_:))))
        
        self.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

//
// MARK: ScrollImageView Controls
//
extension ScrollImageView {
    public func reloadData(_ images: [UIImage]?, configuration: ScrollImageViewConfiguration?) {
        guard let images = images else { return }
        self.images = images
        
        if let config = configuration {
            self.config = config
        }
        
        reloadScrollView()
    }
    
    private func reloadScrollView() {
        guard let images = images, images.count > 0 else { return }
        
        if images.count == 1 {
            addImage(image: images.first ?? UIImage(), at: 0)
            scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height)
            scrollView.isScrollEnabled = false
            pageControl.isHidden = true
            
            return
        }
        
        /// [1] Index 0 : Last Image                        (Fake Image)
        /// [2] Index 1 ~ Index (n) : Images            (Real Images)
        /// [3] Index n+1 : First Image                    (Fake Image)
        
        addImage(image: images.last ?? UIImage(), at: 0) /// [1]
        
        for index in 1..<(images.count+1) {
            addImage(image: images[index-1], at: index) /// [2]
        }
        
        addImage(image: images.first ?? UIImage(), at: images.count+1) /// [3]
        
        scrollView.contentSize = CGSize(width: bounds.width * CGFloat(images.count + 2),
                                        height: bounds.height)
        
        scrollView.isScrollEnabled = true
        
        let rect =  CGRect(x: bounds.width,
                           y: 0,
                           width: bounds.width,
                           height: bounds.height)
        scrollView.scrollRectToVisible(rect, animated: false)
        
        /// PageControl Configuration
        pageControl.numberOfPages = images.count
        pageControl.isHidden = !self.config.usePageControl
        
    }
    
    private func addImage(image: UIImage, at position: Int) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: bounds.width * CGFloat(position),
                                 y: 0,
                                 width: bounds.width,
                                 height: bounds.height)
        
        imageView.contentMode = config.contentMode
        
        scrollView.addSubview(imageView)
    }
    
    @objc fileprivate func onClickScrollView(_ sender: UITapGestureRecognizer) {
        onClickImageHandler?(pageControl.currentPage)
    }
}

//
// MARK: ScrollImageView ScrollView Delegate
//
extension ScrollImageView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let count = self.images?.count else { return }
        
        if scrollView.contentOffset.x == 0 {
            let rect = CGRect(x: bounds.width * CGFloat(count),
                              y: 0,
                              width: bounds.width,
                              height: bounds.height)
            scrollView.scrollRectToVisible(rect, animated: false)
            
        } else if scrollView.contentOffset.x == (bounds.width * CGFloat(count+1)) {
            let rect = CGRect(x: bounds.width,
                              y: 0,
                              width: bounds.width,
                              height: bounds.height)
            scrollView.scrollRectToVisible(rect, animated: false)
        }
        
        let page = (scrollView.contentOffset.x / bounds.width) - 1
        pageControl.currentPage = Int(page)
    }
}
