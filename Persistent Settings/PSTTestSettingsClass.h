//
//  PSTTestSettingsClass.h
//  Persistent Settings
//
//  Created by Chris M on 10/29/15.
//  Copyright © 2015 Chris Manahan. All rights reserved.
//

#import "PSTSettings.h"

@interface PSTTestSettingsClass : PSTSettings

@property (nonatomic) NSNumber *flagTheDoesSomething;
@property (nonatomic) NSString *someStringThatSaysStuff;
@property (nonatomic) NSNumber *someNumberWeWantToStore;

@end
