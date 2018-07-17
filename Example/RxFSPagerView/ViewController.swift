//
//  ViewController.swift
//  RxFSPagerView
//
//  Created by Pircate on 07/17/2018.
//  Copyright (c) 2018 Pircate. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFSPagerView

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pagerView = FSPagerView(frame: view.bounds)
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 2
        pagerView.itemSize = view.bounds.size
        debugPrint(pagerView.itemSize)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        view.addSubview(pagerView)
        
        Driver.of(["0", "1", "2", "3"]).drive(pagerView.rx.items(cellIdentifier: "FSPagerViewCell"))
        { _, item, cell in
            cell.imageView?.image = #imageLiteral(resourceName: "Image")
        }.disposed(by: disposeBag)
        
        pagerView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            debugPrint(indexPath)
        }).disposed(by: disposeBag)
        
        pagerView.rx.modelSelected(String.self).subscribe(onNext: { text in
            debugPrint(text)
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
