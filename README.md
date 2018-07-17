# RxFSPagerView

[![CI Status](https://img.shields.io/travis/Pircate/RxFSPagerView.svg?style=flat)](https://travis-ci.org/Pircate/RxFSPagerView)
[![Version](https://img.shields.io/cocoapods/v/RxFSPagerView.svg?style=flat)](https://cocoapods.org/pods/RxFSPagerView)
[![License](https://img.shields.io/cocoapods/l/RxFSPagerView.svg?style=flat)](https://cocoapods.org/pods/RxFSPagerView)
[![Platform](https://img.shields.io/cocoapods/p/RxFSPagerView.svg?style=flat)](https://cocoapods.org/pods/RxFSPagerView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RxFSPagerView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxFSPagerView'
```

## Usage

```swift
let items = Driver.of(["image0", "image1", "image2", "image3"])
items.drive(pagerView.rx.items(cellIdentifier: "FSPagerViewCell"))
{ _, item, cell in
    cell.imageView?.image = UIImage(named: item)
}.disposed(by: disposeBag)
items.map({ $0.count }).drive(pageControl.rx.numberOfPages).disposed(by: disposeBag)

pagerView.rx.itemSelected.subscribe(onNext: { index in
    debugPrint(index)
}).disposed(by: disposeBag)

pagerView.rx.modelSelected(String.self).subscribe(onNext: { image in
    debugPrint(image)
}).disposed(by: disposeBag)

pagerView.rx.itemScrolled.asDriver().drive(pageControl.rx.currentPage).disposed(by: disposeBag)
```

## Author

Pircate, gao497868860@163.com

## License

RxFSPagerView is available under the MIT license. See the LICENSE file for more info.
