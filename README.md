# Persistent Settings

## Why Use This?
If you find yourself resorting to `NSUserDefaults` a lot to persist a bunch of small pieces of data, whether for app settings, keeping track of if the user took a specific action, or whatever, this'll make your life much easier. Especially if you're using string literals for all of your keys

## Description
`PSTSettings` is a base class that can be subclassed to conveniently store values associated with application settings or any small amount of data that needs to be persisted. 

To use, you can either use this class directly or create a subclass (recommended). In the public interface, create the properties you wish to store. Properties should only be `nonatomic`. No need for any memory management attributes. 

**Note** All of your properties must be an object type, they cannot be primitives. To account for primitives, please use primitive encapsulation types, such as `NSValue` or `NSNumber`. 

### How To Use

Create a subclass that you'll use to to store your settings. You can create multiple subclasses as well, each with a unique set of properties.

#### Create Subclass
```
@interface MySettings : PSTSettings

@property (nonatomic) NSNumber *flagTheDoesSomething;
@property (nonatomic) NSString *someStringThatSaysStuff;
@property (nonatomic) NSNumber *someNumberWeWantToStore;

@end
```

**MAKE SURE YOU READ THIS BECAUSE IT'S SUPER IMPORTANT**

You need to override `+load` on your subclass and call super. This is the only required implementation on your part. This ensures that all of your properties are registered to save automatically into `NSUserDefaults`
```
@implementation MySettings

+ (void)load
{
[super load];
}

@end
```

#### Save new values
```
MySettings *settings = [[MySettings alloc] init];
settings.flagTheDoesSomething = @YES;
[settings setSomeStringThatSaysStuff:@"words!"];
settings.someNumberWeWantToStore = @402;
```

#### Retreiving Values
```
MySettings *settings = [[MySettings alloc] init];
BOOL myBool = [settings.flagTheDoesSomething boolValue];
NSString *myString = [settings someStringThatSaysStuff];
NSInteger myNum = [settings.someNumberWeWantToStore integerValue];
```

## The Insides

The implementation is fairly straightforward if you're familiar with the obj-c runtime. When the class or subclasses are loaded, we grab an array of all of the classes property names. Then we do a half swizzle of all the getters and setters. After swizzling, all getters refer to one single method, and all setters refer to another method. Since the `_cmd` variable still holds the original method name for the getters and setters, we can use that to create a key for that specific property that is then stored or retreived from `NSUserDefaults`.

## TODO:
- Support primitives
- More extensive testing
