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

/**
 *  Swizzles a getter method with our catchall getter
 *
 *  @param methodName Name of getter for property
 */
+ (void)swizzleGetterWithName:(NSString*)methodName
{
    SEL originalSelector = NSSelectorFromString(methodName);
    SEL swizzledSelector = @selector(pst_swizzledGetter);
    [self swizzleSelector:originalSelector with:swizzledSelector];
}

/**
 *  Swizzles a setter method with our catchall setter
 *
 *  @param methodName Name of setter for property
 *
 *  @note Method name must be prefixed with `set`
 */
+ (void)swizzleSetterWithName:(NSString*)methodName
{
    NSAssert([methodName hasPrefix:@"set"], @"method must be a setter");
    SEL originalSelector = NSSelectorFromString(methodName);
    SEL swizzledSelector = @selector(pst_swizzledSetter:);
    [self swizzleSelector:originalSelector with:swizzledSelector];
}

/**
 *  Swizzles two selectors
 *
 *  @param originalSelector Original selector
 *  @param swizzledSelector Selector to swizzle to
 */
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
/**
 *  Get's an array of all the properties for the caller
 *
 *  @return Array of properties as strings
 */
+ (NSArray<NSString*>*)allPropertyNames
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
/**
 *  Generates the key to use with NSUserDefaults for a given property
 *
 *  @param prop Property name
 *
 *  @return Key derived from property and calling class
 */
- (NSString*)keyForProperty:(NSString*)prop
{
    NSString *className = NSStringFromClass([self class]);
    return [NSString stringWithFormat:@"%@_%@", className, prop];
}
/**
 *  Truncates a setter method for the associated property name
 *
 *  @param setter Setter method
 *
 *  @return Property name associated with setter
 *
 *  @note setter must be prefixed with `set`
 */
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
/**
 *  Setter that will be called for all properties
 *
 *  @param val Value passed into the setter
 */
- (void)pst_swizzledSetter:(id)val
{
    NSString *setter = NSStringFromSelector(_cmd);
    NSString *prop = [self propertyFromSetter:setter];
    
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:[self keyForProperty:prop]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  Getter that will be called for all properties
 *
 *  @return Value associated with property being requested
 */
- (id)pst_swizzledGetter
{
    NSString *getter = NSStringFromSelector(_cmd);
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self keyForProperty:getter]];
}

@end
