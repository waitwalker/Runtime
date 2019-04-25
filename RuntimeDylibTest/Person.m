

//
//  Person.m
//  MTTRuntime
//
//  Created by LiuChuanan on 2019/4/12.
//

#import "Person.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "NewPerson.h"

@implementation Person

- (void)name {
    NSLog(@"name");
}


/**
 添加一个newAge

 @param obj obj
 @param _cmd 当前方法的sel
 */
void newAge (id obj, SEL _cmd) {
    NSLog(@"added newAge method:%@",NSStringFromSelector(_cmd));
}


/**
 动态方法解析

 @param sel 不能识别的sel
 @return 消息是否处理了
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return false;
    if (sel == @selector(age)) {
        class_addMethod([self class], @selector(age), (IMP)newAge, "V@:");
        return true;
    }
    return [super resolveInstanceMethod:sel];
}

// MARK: - 快速消息转发
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(age)) {
//        return [[NSObject alloc]init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(age)) {
        return [[NewPerson alloc]init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
