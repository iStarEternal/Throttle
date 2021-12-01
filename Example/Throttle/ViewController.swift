//
//  ViewController.swift
//  Throttle
//
//  Created by Star on 11/24/2021.
//  Copyright (c) 2021 Star. All rights reserved.
//

import UIKit
import Throttle

func testLog(_ item: Any) {
    let components = Calendar.current.dateComponents([.minute, .second, .nanosecond], from: Date())
    guard let minute = components.minute, let second = components.second, let nanosecond = components.nanosecond else { return }
    print(String(format: "<%02d:%02d:%03d>", minute, second, nanosecond / 1000000), item)
}

/// 用来测试释放的
class DeinitTestObject: CustomDebugStringConvertible {
    
    let flag: Any
    
    init(_ flag: Any) {
        self.flag = flag
    }
    
    var debugDescription: String {
        return "DeinitTestObject: \(flag)"
    }
    
    deinit {
        testLog("\(self) deinit")
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tafCallCountLabel: UILabel!
    @IBOutlet weak var tafRunCountLabel: UILabel!
    
    @IBOutlet weak var tbgCallCountLabel: UILabel!
    @IBOutlet weak var tbgRunCountLabel: UILabel!
    
    @IBOutlet weak var debouncerCallCountLabel: UILabel!
    @IBOutlet weak var debouncerRunCountLabel: UILabel!
    
    private let absolteFieldThrottle = Throttle(label: "test", interval: 2)
    private let niceGuyThrottle = Throttle(label: "test", type: .niceGuy, interval: 2)
    private let debouncer = Debouncer(label: "test", interval: 2)
    
    @IBAction func throttleAbsolteFieldAction(_ sender: Any) {
        let callCount = (Int(tafCallCountLabel.text ?? "0") ?? 0) + 1
        tafCallCountLabel.text = String(callCount)
        
        let dto = DeinitTestObject(callCount)
        
        absolteFieldThrottle.call {
            let runCount = (Int(self.tafRunCountLabel.text ?? "0") ?? 0) + 1
            self.tafRunCountLabel.text = String(runCount)
            testLog("Throttle Absolute Field: call \(callCount) run \(runCount)")
            
            _ = dto
        }
        
        testLog("Throttle Absolute Field: call \(callCount)")
    }
    
    @IBAction func throttleNiceGuyAction(_ sender: Any) {
        let callCount = (Int(tbgCallCountLabel.text ?? "0") ?? 0) + 1
        tbgCallCountLabel.text = String(callCount)
        
        let dto = DeinitTestObject(callCount)
        
        niceGuyThrottle.call {
            let runCount = (Int(self.tbgRunCountLabel.text ?? "0") ?? 0) + 1
            self.tbgRunCountLabel.text = String(runCount)
            testLog("Throttle Nice Guy: call \(callCount) run \(runCount)")
            
            _ = dto
        }
        
        testLog("Throttle Nice Guy: call \(callCount)")
    }
    
    @IBAction func debouncerAction(_ sender: Any) {
        let callCount = (Int(debouncerCallCountLabel.text ?? "0") ?? 0) + 1
        debouncerCallCountLabel.text = String(callCount)
        
        let dto = DeinitTestObject(callCount)
        
        debouncer.call {
            let runCount = (Int(self.debouncerRunCountLabel.text ?? "0") ?? 0) + 1
            self.debouncerRunCountLabel.text = String(runCount)
            testLog("Debouncer: call \(callCount) run \(runCount)")
            
            _ = dto
        }
        
        testLog("Debouncer: call \(callCount)")
    }
}

