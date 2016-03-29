//
//  Singleton.h
//  ReadAPI
//
//  Created by shitaotao on 16/3/29.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

#define singleton_h(name) + (instancetype)shared##name;

#if __has_feature(objc_arc)//ARC

#define singleton_m(name)\
static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
+ (instancetype)shared##name{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc]init];\
    });\
    return _instance;\
}\
+ (id)copyWithZone:(struct _NSZone *)zone{\
    return _instance;\
}

#else // 非ARC

#define singleton_m(name)\
static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
+ (instancetype)shared##name{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc]init];\
    });\
    return _instance;\
}\
+ (id)copyWithZone:(struct _NSZone *)zone{\
    return _instance;\
}\
- (oneway void)release\
{\
}\
- (id)autorelease\
{\
    return _instance;\
}\
- (id)retain\
{\
    return _instance;\
}\
- (NSUInteger)retainCount \
{\
    return 1;\
}
#endif


#endif /* Singleton_h */
