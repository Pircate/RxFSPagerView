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
                let source = source.map({ s -> S in
                    let items = Array(s)
                    self.base.numberOfSections = items.count
                    let max = self.base.isInfinite && (items.count > 1 || !self.base.removesInfiniteLoopForSingleItem) ? Int8.max : 1
                    var actualItems: [S.Element] = []
                    (0...max - 1).lazy.forEach({ _ in
                        actualItems += Array(items)
                    })
                    self.base.numberOfItems = actualItems.count
                    return actualItems as! S
                })
                return self.base.collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)(source)
            }
    }
    
    var itemSelected: ControlEvent<Int> {
        let source = base.collectionView.rx.delegate
            .methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:)))
            .map { return try castOrThrow(IndexPath.self, $0[1]).item % self.base.numberOfSections }
        return ControlEvent(events: source)
    }
    
    func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = itemSelected.flatMap { [weak view = self.base.collectionView] item -> Observable<T> in
            guard let view = view else { return Observable.empty() }
            return Observable.just(try view.rx.model(at: IndexPath(item: item, section: 0)))
        }
        return ControlEvent(events: source)
    }
    
    var itemScroll: ControlEvent<Int> {
        let source = base.collectionView.rx.didScroll.map({ _ -> Int in
            guard self.base.numberOfSections > 0 else { return 0 }
            let currentIndex = lround(Double(self.base.scrollOffset)) % self.base.numberOfSections
            if currentIndex != self.base.currentIndex {
                self.base.currentIndex = currentIndex
            }
            return self.base.currentIndex
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
