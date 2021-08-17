//
//  FSPagerView+Rx.swift
//  RxFSPagerView
//
//  Created by GorXion on 2018/7/17.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: FSPagerView {
    
    typealias ConfigureCell<S: Sequence, Cell> = (Int, S.Iterator.Element, Cell) -> Void
    
    func items<S: Sequence, Cell: FSPagerViewCell, O: ObservableType>(
        cellIdentifier: String,
        cellType: Cell.Type = Cell.self
    ) -> (_ source: O) -> (_ configureCell: @escaping ConfigureCell<S, Cell>) -> Disposable
    where O.Element == S {
        base.collectionView.dataSource = nil
        return { source in
            let source = source.map { sequence -> [S.Element] in
                let items = Array(sequence)
                
                let numberOfItems = Int(Int16.max)
                self.base.numberOfItems = numberOfItems
                
                guard !items.isEmpty else {
                    return []
                }
                
                /// 用于计算 index
                self.base.numberOfSections = items.count
                
                let shouldLoop = items.count > 1 || !self.base.removesInfiniteLoopForSingleItem
                let max = self.base.isInfinite && shouldLoop ? numberOfItems / items.count : 1
                
                return (0..<max).lazy.reduce([]) { result, _ in
                    result + items
                }
            }
            
            return self.base.collectionView.rx.items(
                cellIdentifier: cellIdentifier,
                cellType: cellType
            )(source)
        }
    }
}

public extension Reactive where Base: FSPagerView {
    
    var itemSelected: ControlEvent<Int> {
        let source = base.collectionView.rx.itemSelected.map {
            $0.item % self.base.numberOfSections
        }
        
        return ControlEvent(events: source)
    }
    
    var itemDeselected: ControlEvent<Int> {
        let source = base.collectionView.rx.itemDeselected.map {
            $0.item % self.base.numberOfSections
        }
        
        return ControlEvent(events: source)
    }
    
    func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        return base.collectionView.rx.modelSelected(modelType)
    }
    
    var itemScrolled: ControlEvent<Int> {
        let source = base.collectionView.rx.didScroll.flatMap { _ -> Observable<Int> in
            guard self.base.numberOfSections > 0 else { return .never() }
            
            let currentIndex = lround(Double(self.base.scrollOffset)) % self.base.numberOfSections
            
            guard currentIndex != self.base.currentIndex else { return .never() }
            
            self.base.currentIndex = currentIndex
            return Observable.just(currentIndex)
        }
        
        return ControlEvent(events: source)
    }
}

public extension Reactive where Base: FSPagerView {
    
    func deselectItem(animated: Bool) -> Binder<Int> {
        return Binder(base) { this, item in
            this.collectionView.deselectItem(
                at: IndexPath(item: item, section: 0),
                animated: animated
            )
        }
    }
}
