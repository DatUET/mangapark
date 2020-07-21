//
//  swift
//  manga_comic
//
//  Created by gem on 7/8/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class ContentChapterViewController: UIViewController {
    var urlContentChap = ""
    var mangaPark = MangaPark()
    
    @IBOutlet weak var commicImage: UIImageView!
    @IBOutlet weak var backPage: UIButton!
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var currentPageIndex: UILabel!
    @IBOutlet weak var scrollImage: UIScrollView!
    @IBOutlet var swipeLeft: UISwipeGestureRecognizer!
    @IBOutlet var swipeRight: UISwipeGestureRecognizer!
    
    var listImageOfChapter = [String]() // danh sách link imaga cho mỗi chap, sẽ đc thay đổi khi đọc 1 chap
    var currentIndexPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollImage.minimumZoomScale = 1.0
        scrollImage.maximumZoomScale = 10.0
        mangaPark.getListImageChapter(url: urlContentChap, callback: addImaga(arr:))
        backPage.addTarget(self, action: #selector(backPageAction), for: .touchUpInside)
        nextPage.addTarget(self, action: #selector(nextPageAction), for: .touchUpInside)
        swipeRight.addTarget(self, action: #selector(backPageAction))
        swipeLeft.addTarget(self, action: #selector(nextPageAction))
        scrollImage.addGestureRecognizer(swipeLeft)
        scrollImage.addGestureRecognizer(swipeRight)
    }
    
    func addImaga(arr: [String]) {
        for i in arr {
            listImageOfChapter.append(i)
        }
        commicImage.sd_setImage(with: URL(string: listImageOfChapter[0]), placeholderImage: UIImage(named: "down"))
        setupLabelCurrentPage()
    }
    
    func setupLabelCurrentPage() {
        if listImageOfChapter.isEmpty {
            currentPageIndex.text = "0/0"
        } else {
            currentPageIndex.text = "\(currentIndexPage + 1)/\(listImageOfChapter.count)"
        }
    }

    @objc func backPageAction() {
        if currentIndexPage > 0 {
            nextPage.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            currentIndexPage -= 1
            currentPageIndex.text = "\(currentIndexPage + 1)/\(listImageOfChapter.count)"
            commicImage.sd_setImage(with: URL(string: listImageOfChapter[currentIndexPage]), placeholderImage: UIImage(named: "down"))
        }
        if currentIndexPage == 0 {
            backPage.setTitleColor(UIColor.black, for: .normal)
        } else {
            backPage.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
        }
    }
    
    @objc func nextPageAction() {
        if currentIndexPage < listImageOfChapter.count - 1 {
            backPage.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            currentIndexPage += 1
            currentPageIndex.text = "\(currentIndexPage + 1)/\(listImageOfChapter.count)"
            commicImage.sd_setImage(with: URL(string: listImageOfChapter[currentIndexPage]), placeholderImage: UIImage(named: "down"))
        }
        if currentIndexPage == listImageOfChapter.count - 1 {
            nextPage.setTitleColor(UIColor.black, for: .normal)
        } else {
            nextPage.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listImageOfChapter.removeAll()
    }
}

extension ContentChapterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.commicImage
    }
}
