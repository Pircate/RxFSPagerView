//
//  FSPagerView+Rx.swift
//  RxFSPagerView
//
//  Created by GorXion on 2018/7/17.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: FSPagerView {
    
    func items<S: Sequence, Cell: FSPagerViewCell, O : ObservableType>
        (cellIdentifier: String, cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable where O.E == S {
            base.collectionView.dataSource = nil
            return { source in
                let source = source.map({ sequence -> S in
                    let items = Array(sequence)
                    self.base.numberOfSections = items.count
                    let max = self.base.isInfinite && (items.count > 1 || !self.base.removesInfiniteLoopForSingleItem) ? Int8.max : 1
                    var actualItems: [S.Element] = []
                    (0..<max).lazy.forEach({ _ in actualItems += items })
                    self.base.numberOfItems = actualItems.count
                    return actualItems as! S
                })
                return self.base.collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)(source)
            }
    }
    
    var itemSelected: ControlEvent<Int> {
        let source = base.collectionView.rx.itemSelected.map { $0.item % self.base.numberOfSections }
        return ControlEvent(events: source)
    }
    
    func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        return base.collectionView.rx.modelSelected(modelType)
    }
    
    var itemScrolled: ControlEvent<Int> {
        let source = base.collectionView.rx.didScroll.flatMap({ _ -> Observable<Int> in
            guard self.base.numberOfSections > 0 else { return Observable.never() }
            let currentPage = lround(Double(self.base.scrollOffset)) % self.base.numberOfSections
            if currentPage != self.base.currentPage {
                self.base.currentPage = currentPage
                return Observable.just(currentPage)
            }
            return Observable.never()
        })
        return ControlEvent(events: source)
    }
}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}
