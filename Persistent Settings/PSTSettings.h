//
//  PSTSettings.h
//  Persistent Settings
//
//  Created by Chris M on 10/28/15.
//  Copyright © 2015 Chris Manahan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _PST [PSTSettings sharedSettings]

@interface PSTSettings : NSObject

@property (nonatomic) NSNumber *prop0;
@property (nonatomic) NSNumber *prop1;
@property (nonatomic) NSNumber *prop2;

+ (instancetype)sharedSettings;

@end
