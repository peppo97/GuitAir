//
//  PlayingBuffer.swift
//  GuitAir WatchKit Extension
//
//  Created by Gennaro Giaquinto on 16/07/2019.
//  Copyright © 2019 Gennaro Giaquinto. All rights reserved.
//

import Foundation

class PlayingBuffer {
    // MARK: Properties
    
    var buffer = [Double]()
    var size = 0
    
    // MARK: Initialization
    
    init(size: Int) {
        self.size = size
        self.buffer = [Double](repeating: 0.0, count: self.size)
    }
    
    // MARK: Running Buffer
    
    func addSample(_ sample: Double) {
        buffer.insert(sample, at:0)
        if buffer.count > size  {
            buffer.removeLast()
        }
    }
    
    func reset() {
        buffer.removeAll(keepingCapacity: true)
    }
    
    func isFull() -> Bool {
        return size == buffer.count
    }
    
    func sum() -> Double {
        return buffer.reduce(0.0, +)
    }
    
    func min() -> Double {
        var min = 0.0
        if let bufMin = buffer.min() {
            min = bufMin
        }
        return min
    }
    
    func max() -> Double {
        var max = 0.0
        if let bufMax = buffer.max() {
            max = bufMax
        }
        return max
    }
    
    func recentMean() -> Double {
        // Calculate the mean over the beginning half of the buffer.
        let recentCount = self.size / 2
        var mean = 0.0
        
        if (buffer.count >= recentCount) {
            let recentBuffer = buffer[0..<recentCount]
            mean = recentBuffer.reduce(0.0, +) / Double(recentBuffer.count)
        }
        
        return mean
    }
}
