//
//  PSTSettings.m
//  Persistent Settings
//
//  Created by Chris M on 10/28/15.
//  Copyright © 2015 Chris Manahan. All rights reserved.
//

#import "PSTSettings.h"

#import <objc/runtime.h>

@implementation PSTSettings

#pragma mark - Swizzling
+ (void)load
{
//    static dispatch_once_t onceToken;
//    //
//    dispatch_once(&onceToken, ^{
        // get the names of all the properties
        NSArray *propertyNames = [self allPropertyNames];
        
        // swizzle getters
        for (NSString *prop in propertyNames)
        {
            [self swizzleGetterWithName:prop];
            
            // change prop name for setter selector name
            NSString *setter = [prop stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[prop substringToIndex:1] uppercaseString]];
            setter = [NSString stringWithFormat:@"set%@:", setter];
            [self swizzleSetterWithName:setter];
        }
//    });
}

+ (void)swizzleGetterWithName:(NSString*)methodName
{
    SEL originalSelector = NSSelectorFromString(methodName);
    SEL swizzledSelector = @selector(pst_swizzledGetter);
    [self swizzleSelector:originalSelector with:swizzledSelector];
}

+ (void)swizzleSetterWithName:(NSString*)methodName
{
    NSAssert([methodName hasPrefix:@"set"], @"method must be a setter");
    SEL originalSelector = NSSelectorFromString(methodName);
    SEL swizzledSelector = @selector(pst_swizzledSetter:);
    [self swizzleSelector:originalSelector with:swizzledSelector];
}

+ (void)swizzleSelector:(SEL)originalSelector with:(SEL)swizzledSelector
{
    /**
     *  Adapted from http://nshipster.com/method-swizzling/
     *  Thanks Mattt
     */

    Class class = [self class];
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    class_replaceMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
}

#pragma mark - Helpers
+ (NSArray *)allPropertyNames
{
    /**
     * Adapted from http://stackoverflow.com/a/11774276/544094
     */
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

- (NSString*)keyForProperty:(NSString*)prop
{
    NSString *className = NSStringFromClass([self class]);
    return [NSString stringWithFormat:@"%@_%@", className, prop];
}

- (NSString*)propertyFromSetter:(NSString*)setter
{
    NSAssert([setter hasPrefix:@"set"], @"method must be a setter");
    // trim off the 'set'
    NSString *prop = [setter substringFromIndex:3];
    // set the first letter to lower
    prop = [prop stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                         withString:[[prop substringToIndex:1] lowercaseString]];
    prop = [prop substringToIndex:prop.length -1];
    return prop;
}

#pragma mark - Swizzled Methods

- (void)pst_swizzledSetter:(id)val
{
    NSString *setter = NSStringFromSelector(_cmd);
    NSString *prop = [self propertyFromSetter:setter];
    
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:[self keyForProperty:prop]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)pst_swizzledGetter
{
    NSString *getter = NSStringFromSelector(_cmd);
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self keyForProperty:getter]];
}

@end
