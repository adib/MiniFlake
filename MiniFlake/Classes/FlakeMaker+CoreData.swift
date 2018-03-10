//
//  FlakeMaker+CoreData.swift
//  MiniFlake
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

extension InProcessFlakeMaker {
    /**
     Returns the ID generator for the specified managed object context.
     */
    static func flakeMaker(managedObjectContext: NSManagedObjectContext) -> FlakeMaker {
        let objectName = "com.basilsalad.FlakeMaker.managedObjectContext"
        let userInfo = managedObjectContext.userInfo
        if let maker = userInfo[objectName] as? InProcessFlakeMaker {
            return maker
        }
        let fm = InProcessFlakeMaker()!
        userInfo[objectName] = fm
        return fm
    }
}

public extension NSManagedObjectContext {
    /**
     Returns the next ID for the managed object context. Creates an ID generator if necessary in the `userInfo` dictionary.
     */
    @objc
    public func nextFlakeID() -> Int64 {
        return InProcessFlakeMaker.flakeMaker(managedObjectContext:self).nextValue()
    }
}

