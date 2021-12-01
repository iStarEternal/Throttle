//
//  Throttle.swift
//  Star
//
//  Created by Star on 2021/11/24.
//

import Foundation
import Dispatch

/// 节流阀
/// 特性：任务执行开始的 interval 秒内，后续添加的任务不会执行。
public class Throttle {
    
    public enum `Type` {
        /// 绝对领域，这个类型下，会阻止任务执行过程中添加的所有任务。
        case absoluteField
        /// 好好先生，这个类型下，虽然会阻止任务执行过程中添加的所有任务，但是任务完成之后，会执行最后一次添加的任务。
        case niceGuy
    }
    
    private let lock = ThrottleLock()
    private let queue: DispatchQueue
    private let interval: TimeInterval
    private let type: `Type`
    private var workItem: DispatchWorkItem?
    private var callback: (() -> Void)?
    private var prevCallbackDate: Date = Date(timeIntervalSince1970: 0)
    
    public init(label: String, type: `Type` = .absoluteField, interval: TimeInterval = 1.0) {
        self.queue = DispatchQueue(label: label)
        self.type = type
        self.interval = interval
    }
    
    public func call(_ callback: @escaping () -> Void) {
        self.lock.sync {
            self.workItem?.cancel()
            self.workItem = nil
            self.callback = nil
            
            let delay: DispatchTimeInterval
            let timeInterval = Date().timeIntervalSince1970 - prevCallbackDate.timeIntervalSince1970
            if timeInterval > self.interval {
                delay = DispatchTimeInterval.milliseconds(0)
            } else {
                switch self.type {
                case .absoluteField:
                    return
                case .niceGuy:
                    delay = DispatchTimeInterval.milliseconds(Int((self.interval - timeInterval) * 1000))
                }
            }
            let workItem = createWorkItem()
            self.queue.asyncAfter(deadline: .now() + delay, execute: workItem)
            self.workItem = workItem
            self.callback = callback
        }
    }
    
    private func createWorkItem() -> DispatchWorkItem {
        DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.prevCallbackDate = Date()
            if let callback = self.callback {
                DispatchQueue.main.async {
                    callback()
                }
            }
            self.workItem = nil
            self.callback = nil
        }
    }
}

/// 防抖
/// 特性：每次调用时，重新以调用时间开始计算，过了 interval 秒后，最后一次任务才会被执行。
/// 适用场景：点击某个按钮0.5秒后，让按钮隐藏，但是一直点击则不让按钮隐藏，以最后一次点击为准。
public class Debouncer {
    
    private let lock = ThrottleLock()
    private let queue: DispatchQueue
    private let interval: TimeInterval
    private var workItem: DispatchWorkItem?
    private var callback: (() -> Void)?
    
    public init(label: String, interval: TimeInterval = 1.0) {
        self.queue = DispatchQueue(label: label)
        self.interval = interval
    }
    
    public func call(_ callback: @escaping () -> Void) {
        self.lock.sync {
            self.workItem?.cancel()
            self.workItem = nil
            self.callback = nil
            
            let workItem = self.createWorkItem()
            self.queue.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(Int(self.interval * 1000)), execute: workItem)
            self.workItem = workItem
            self.callback = callback
        }
    }
    
    private func createWorkItem() -> DispatchWorkItem {
        DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            if let callback = self.callback {
                DispatchQueue.main.async {
                    callback()
                }
            }
            self.workItem = nil
            self.callback = nil
        }
    }
}

private struct ThrottleLock {
    private let lock = DispatchSemaphore(value: 1)
    func sync(execute: () -> Void) {
        lock.wait()
        execute()
        lock.signal()
    }
}
