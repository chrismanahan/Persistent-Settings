//
//  PSTSettings.h
//  Persistent Settings
//
//  Created by Chris M on 10/28/15.
//  Copyright © 2015 Chris Manahan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @discussion @p PSTSettings is a base class that can be subclassed to conveniently
 *              store values associated with application settings or any small amount
 *              of data that needs to be persisted.
 *
 *              To use, you can either use this class directly or create a 
 *              subclass. In the public interface, create the properties you wish 
 *              to store. Properties should only be @p nonatomic. No need for
 *              any memory management attributes. 
 *
 *  @note       Properties can only be objects. To store a primitive, use the
 *              appropriate object encapsulation, such as @p NSValue or @p NSNumber
 *
 *  @attention  If you subclass @p PSTSettings, you MUST override @p +load and call super. 
 *              See example below
 *
 *  @b Example
 *
 @code
 
 @interface MySettings : PSTSettings
 
 @property (nonatomic) NSNumber *someNum;
 @property (nonatomic) NSNumber *someBool;
 
 @end
 ...
 @implementation MySettings
 
 + (void)load
 {
    [super load];
 }
 
 @end
 
 ...
 // somewhere far away
 MySettings *settings = [[MySettings alloc] init];
 BOOL myBool = [settings.someBool boolValue];
 settings.someBool = @(YES);
 ...
 
 @endcode
 *
 *
 */
@interface PSTSettings : NSObject

@end
