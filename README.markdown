# MiniFlake

[![CI Status](http://img.shields.io/travis/adib/MiniFlake.svg?style=flat)](https://travis-ci.org/adib/MiniFlake)
[![Version](https://img.shields.io/cocoapods/v/MiniFlake.svg?style=flat)](http://cocoapods.org/pods/MiniFlake)
[![License](https://img.shields.io/cocoapods/l/MiniFlake.svg?style=flat)](http://cocoapods.org/pods/MiniFlake)
[![Platform](https://img.shields.io/cocoapods/p/MiniFlake.svg?style=flat)](http://cocoapods.org/pods/MiniFlake)

A Swift micro-framework for generating compact identifiers that are time ordered in without the need for synchronization.

## Purpose

- Generate identifiers for data objects.
- Fits as positive values in 64-bit integer data type — easy to process and store.
- Roughly time-ordered identifiers.

## Intended uses

- Great for use in Core Data as a way to generate permanent identifiers without needing to save the objects beforehand.
- Also works well in iCloud scenarios — single-user, multiple devices, and no server-based logic.
- Should also function pretty good in collaborative multi-device and multi-user scenarios with less than four million concurrent users.
- Works great as server-side ID generators, even distributed systems environments.

## Compatibility

- Xcode 9.2
- Swift 4.0
- macOS 10.12+
- iOS 10.3+
- tvOS 10.2+
- watchOS 3.2+

## Installation

MiniFlake is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MiniFlake'
```

## Usage

First  import the library in the top of your source file:

```Swift
import MiniFlake
```

### Core Data

In your `NSManagedObject` subclass, override `awakeFromInsert` and use MiniFlake's `NSManagedObjectContext` extension method `nextFlakeID` to pre-populate your object's identifier. You would need to have an indexed attribute of type `Int64` as this identifier.

```Swift
override func awakeFromInsert() {
    super.awakeFromInsert()
    self.primitiveIdentifierValue = self.managedObjectContext!.nextFlakeID()
    // ... continue initialization ...
}
```

### Other Entity Types

The `nextFlakeID` method is also available as an extension to `Thread`. You can use this to generate identifiers for your custom persistence objects.

```Swift
let generatedID = Thread.current.nextFlakeID()
```

**Always** use `Thread.current` and do not call the method for another thread object since ID generation is not thread-safe.

### Advanced Uses

The primary classes are `FlakeMaker` and `InProcessFlakeMaker`. The former requires you to provide a unique instance number whereas the latter will manage these instance numbers for you. Note that instance numbers are 10-bit values, hence there cannot be more than 1024 generator instances at any given moment or the identifiers may overlap.  Call method `nextValue()` on objects of both classes to generate ID values.

```Swift
let generator = InProcessFlakeMaker()
let runCount = 100
var results = Set<Int64>(minimumCapacity:runCount)
for _ in 0..<runCount {
    results.insert(generator.nextValue())
}
```

### Objective-C

The `nextFlakeID` extension methods are available to call from Objective-C sources, which should cover most use cases. However the `FlakeMaker` and `InProcessFlakeMaker` classes are Swift-only.

Importing into Objective-C source file:

```Objective-C
#import <MiniFlake/MiniFlake-Swift.h>
```

Setup of Core Data object:

```Objective-C
-(void) awakeFromInsert {
    [super awakeFromInsert];
    self.primitiveIdentifierValue = [self.managedObjectContext nextFlakeID];
    // ... continue initialization ...
}
```

Generic identifier creation:

```Objective-C
int64_t generatedID = [NSThread.currentThread nextFlakeID];
```

## Example

Open `MiniFlake.xcworkspace` from the `Example` folder and run the `MiniFlake_Example.app` target using Xcode. This is a Mac app that generates an amount of identifiers into a text view, ready for copy-pasting. The main functionality that calls the library is inside the class `ViewController`, method `startGenerate()`.


## How it works

The identifier is inspired by Twitter’s Snowflake ID generator, in which each identifier value is composed by the following components.

1. 41 bits timestamp, millisecond precision with a custom epoch.
2. 10 bits generator instance identifier.
3. 12 bits sequence number.

The timestamp occupies the more significant bits. With 41 bits it would be good for over 178 years before wrapping around. The custom epoch is 1 March 2018, hence the identifier  won’t wrap around until the year 2196. Even then it would still work but generates negative values instead, hence easily detectable and fixable.

With 12 bits available for the sequence number, each worker can generate **over four thousand unique values per millisecond**. Because it can count up to 4095 per millisecond, there’s much less likely to have an ID clash as opposed to using a plain Unix timestamp as an ID generator. Moreover an overflow in this field would get passed on to the timestamp field, hence the generator would still create valid values.

The *instance identifier* helps mitigate the possibility of duplicates. In server-based environments, you would associate this with the service worker number — the instance number of the microservice which hands out these ID values. In on-device scenarios, I’ve created category methods that associates the ID generator with either the thread or the Core Data context.


## Author

Copyright © Sasmito Adibowo  
http://cutecoder.org

## License

MIT license, a.k.a. Simplified BSD. See the `LICENSE.markdown` file for more information.
