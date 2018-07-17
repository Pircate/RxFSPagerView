//
//  FSPageControl+Rx.swift
//  RxFSPagerView
//
//  Created by GorXion on 2018/7/17.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: FSPageControl {
    
    var numberOfPages: Binder<Int> {
        return Binder(base) { this, numberOfPages in
            this.numberOfPages = numberOfPages
        }
    }
    
    var currentPage: Binder<Int> {
        return Binder(base) { this, currentPage in
            this.currentPage = currentPage
        }
    }
}
