//
//  Persistent_SettingsTests.m
//  Persistent SettingsTests
//
//  Created by Chris M on 10/28/15.
//  Copyright © 2015 Chris Manahan. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PSTSettings.h"

@interface Persistent_SettingsTests : XCTestCase

@end

@implementation Persistent_SettingsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    int prop0 = [[_PST prop0] intValue];
    int prop1 = [[_PST prop1] intValue];
    
    NSLog(@"%i, %i", prop0, prop1);
    
    [_PST setProp0:@(prop0+1)];
    [_PST setProp1:@(prop1+1)];
    NSNumber *prop0a = [_PST prop0];
    NSNumber *prop1a = _PST.prop1;
    NSLog(@"%@, %@", prop0a, prop1a);
    
//    XCTAssert(prop0 != prop0a && prop1 != prop1a);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
