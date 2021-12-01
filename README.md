# Throttle

两种节流阀，一种防抖动

[![CI Status](https://img.shields.io/travis/Star/Throttle.svg?style=flat)](https://travis-ci.org/Star/Throttle)
[![Version](https://img.shields.io/cocoapods/v/Throttle.svg?style=flat)](https://cocoapods.org/pods/Throttle)
[![License](https://img.shields.io/cocoapods/l/Throttle.svg?style=flat)](https://cocoapods.org/pods/Throttle)
[![Platform](https://img.shields.io/cocoapods/p/Throttle.svg?style=flat)](https://cocoapods.org/pods/Throttle)

## How to use
### AbsolteField
这个类型下，会阻止任务执行过程中添加的所有任务。
```swift
    private let throttle = Throttle(label: "test", interval: 2)
    func someButtonAction() {
        throttle.call {
            // do something
        }
    }
```
### NiceGuy
这个类型下，虽然会阻止任务执行过程中添加的所有任务，但是任务完成之后，会执行最后一次添加的任务。
```swift
    private let throttle = Throttle(label: "test", type: .niceGuy, interval: 2)
    func someButtonAction() {
        throttle.call {
            // do something
        }
    }
```
### Debouncer
每次调用时，重新以调用时间开始计算，过了 interval 秒后，最后一次任务才会被执行。
```swift
    private let debouncer = Debouncer(label: "test", interval: 2)
    func someButtonAction() {
        debouncer.call {
            // do something
        }
    }
```

## Installation

Throttle is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Throttle', :git => 'https://github.com/iStarEternal/Throttle.git'
```

## Author

Star, 576681253@qq.com

## License

Throttle is available under the MIT license. See the LICENSE file for more info.
