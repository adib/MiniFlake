//
//  MiniFlakeTests.swift
//  MiniFlakeTests
//
//  Copyright © Sasmito Adibowo
//  http://cutecoder.org
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import CoreData
import XCTest
@testable import MiniFlake

class MiniFlakeTests: XCTestCase {
    
    static let inProcessFlakeMakerLock = DispatchQueue(label:"com.basilsalad.MiniFlakeTests")
    
    func testSmallSimple() {
        let runCount = 100
        let generator = FlakeMaker(instanceNumber:1)
        var results = Set<Int64>(minimumCapacity:runCount)
        for _ in 0..<runCount {
            results.insert(generator.nextValue())
        }
        XCTAssertEqual(results.count, runCount, "Duplicate IDs found")
        for val in results {
            XCTAssertGreaterThan(val, 0, "Negative ID: \(val)")
        }
    }
    
    /**
     Test generate a two million IDs from two different threads and ensure they're unique.
     */
    func testTwoMillion() {
        let runCount = 1_000_000
        let gen1 = FlakeMaker(instanceNumber: 1)
        let gen2 = FlakeMaker(instanceNumber: 2)
        var mergedResults = Set<Int64>(minimumCapacity:runCount*2)
        let mergeQueue = DispatchQueue(label: "Merge")
        
        func runner(generator: FlakeMaker) -> Set<Int64> {
            var results = Set<Int64>(minimumCapacity:runCount)
            for _ in 0..<runCount {
                results.insert(generator.nextValue())
            }
            return results
        }
        let runner1 = self.expectation(description: "Runner 1 done")
        let runner2 = self.expectation(description: "Runner 2 done")

        DispatchQueue.global(qos: .userInitiated).async {
            let set1 = runner(generator: gen1)
            mergeQueue.async {
                mergedResults.formUnion(set1)
                runner1.fulfill()
            }
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let set2 = runner(generator: gen2)
            mergeQueue.async {
                mergedResults.formUnion(set2)
                runner2.fulfill()
            }
        }
        self.wait(for: [runner1,runner2], timeout: 60)
        XCTAssertEqual(mergedResults.count, runCount * 2, "Unexpected result count")
    }
    
    func testPerformanceOneMillion() {
        let runCount = 1_000_000
        let gen = FlakeMaker(instanceNumber: 3)
        self.measure {
            for _ in 0..<runCount {
                _ = gen.nextValue()
            }
        }
    }
    
    func testSameThread() {
        let myClass = type(of:self)
        myClass.inProcessFlakeMakerLock.sync {
            let obj1 = InProcessFlakeMaker.flakeMaker(thread: Thread.current)
            let obj2 = InProcessFlakeMaker.flakeMaker(thread: Thread.current)
            XCTAssertTrue(obj1 === obj2, "Thread storage data failed")
        }
    }
    
    func testSameManagedObjectContext() {
        let ctx = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        let myClass = type(of:self)
        myClass.inProcessFlakeMakerLock.sync {
            let obj1 = InProcessFlakeMaker.flakeMaker(managedObjectContext: ctx)
            let obj2 = InProcessFlakeMaker.flakeMaker(managedObjectContext: ctx)
            XCTAssertTrue(obj1 === obj2, "Core Data Context storage failed")
        }
    }
    
    func testMaxInstances() {
        let myClass = type(of:self)
        myClass.inProcessFlakeMakerLock.sync {
            let maxInstances = InProcessFlakeMaker.instancesAvailable
            var allInstances = Set<InProcessFlakeMaker>()
            allInstances.reserveCapacity(Int(maxInstances))
            
            for _ in 0..<maxInstances {
                allInstances.update(with: InProcessFlakeMaker())
            }
            XCTAssertEqual(allInstances.count, Int(maxInstances), "Instance numbers overlap")
            XCTAssertEqual(InProcessFlakeMaker.instancesAvailable, 0, "Unit test should exhaust instance numbers")
            allInstances.removeFirst()
            XCTAssertEqual(InProcessFlakeMaker.instancesAvailable, 1, "Object destruction should make one instance number available")
            let generator = InProcessFlakeMaker()
            allInstances.update(with: generator)
            let generatedValue = generator.nextValue()
            XCTAssertGreaterThan(generatedValue, 0, "Invalid Generated value")
        }
    }
    
}
