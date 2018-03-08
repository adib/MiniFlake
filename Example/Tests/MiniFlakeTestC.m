//
//  MiniFlakeTestC.m
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

#import <CoreData/CoreData.h>
#import <XCTest/XCTest.h>
#import <MiniFlake/MiniFlake-Swift.h>

/**
 Unit test to show how to use FlakeMaker from Objective-C.
 */
@interface MiniFlakeTestC : XCTestCase

@end

@implementation MiniFlakeTestC


/**
  Generic thread-based ID generator.
 */
- (void)testThreadFlake {
    NSInteger value = NSThread.currentThread.nextFlakeID;
    XCTAssertGreaterThan(value, 0, "Zero ID value");
}


/**
 Use the `NSManagedObjectContext` extension to generate identifiers for Core Data object.
 */
-(void) testCoreDataFlake {
    NSManagedObjectContext* ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    NSInteger __block generatedValue = -2;
    [ctx performBlockAndWait:^{
        generatedValue = ctx.nextFlakeID;
    }];
    XCTAssertGreaterThan(generatedValue, 0, "Zero ID value");
}
@end
