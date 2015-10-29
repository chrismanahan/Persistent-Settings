//
//  Persistent_SettingsTests.m
//  Persistent SettingsTests
//
//  Created by Chris M on 10/28/15.
//  Copyright © 2015 Chris Manahan. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PSTTestSettingsClass.h"

@interface Persistent_SettingsTests : XCTestCase

@end

@implementation Persistent_SettingsTests

- (void)testSetters
{
    PSTTestSettingsClass *settings = [[PSTTestSettingsClass alloc] init];
    
    settings.flagTheDoesSomething = @YES;
    settings.someStringThatSaysStuff = @"words!";
    settings.someNumberWeWantToStore = @402;
    
    XCTAssert([settings.flagTheDoesSomething isEqual:@YES]);
    XCTAssert([settings.someStringThatSaysStuff isEqualToString:@"words!"]);
    XCTAssert([settings.someNumberWeWantToStore isEqualToNumber:@402]);
}

- (void)testGetters
{
    PSTTestSettingsClass *settings = [[PSTTestSettingsClass alloc] init];
    
    XCTAssert([settings.flagTheDoesSomething isEqual:@YES]);
    XCTAssert([settings.someStringThatSaysStuff isEqualToString:@"words!"]);
    XCTAssert([settings.someNumberWeWantToStore isEqualToNumber:@402]);
}

@end
