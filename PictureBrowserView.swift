//
//  PictureBrowserView.swift
//  PictureBrowser
//
//  Created by  lisit&hua on 2019/9/11.
//  Copyright © 2019 lisitapp. All rights reserved.
//

import UIKit

class PictureBrowserItemView: UIScrollView {
    
    var currentScale: CGFloat = 1.0
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 20, y: 0, width: frame.width - 40, height: frame.height))
        view.isUserInteractionEnabled = true
        let doubelTapG = UITapGestureRecognizer(target: self, action: #selector(doubelAction(_ :)))
        doubelTapG.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubelTapG)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor.black
        maximumZoomScale = 5
        zoomScale = 1
        delegate = self
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func doubelAction(_ sender: UITapGestureRecognizer) {
        self.zoomScale = currentScale
    }

    public func loadData(_ image: UIImage) {
        let height = image.size.height / image.size.width  * frame.width
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: height)
        scrollViewDidZoom(self)
        let maxSize = frame.size
        let widthRatio = maxSize.width / image.size.width
        let heightRatio = maxSize.height / image.size.height
        let initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio
        minimumZoomScale = initialZoom
        currentScale = zoomScale
        imageView.image = image
    }
}

extension PictureBrowserItemView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX =  (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
}


class PictureBrowserView: UIView {
    
    lazy var pageView: UIPageControl = {
        let view = UIPageControl(frame: CGRect(x: (frame.width - 100)/2, y: frame.height - 100, width: 100, height: 20))
        view.currentPage = 0
        view.hidesForSinglePage = true
        view.pageIndicatorTintColor = UIColor.white
        view.currentPageIndicatorTintColor = UIColor.red
        return view
    }()
    
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        view.backgroundColor = UIColor.clear
        view.isPagingEnabled = true
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        addSubview(pageView)
    }
    
    public func loadData(_ dataArray: [UIImage]) {
        var index = 0
        for image in dataArray {
            let photoView = PictureBrowserItemView(frame: CGRect(x: CGFloat(index) * frame.width, y: 0, width: frame.width, height: frame.height))
            photoView.loadData(image)
            scrollView.addSubview(photoView)
            index += 1
        }
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(index), height: frame.height - 1)
        pageView.numberOfPages = dataArray.count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PictureBrowserView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
        pageView.currentPage = Int(currentPage)
    }
}

