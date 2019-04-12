//
//  main.m
//  RuntimeDylibTest
//
//  Created by LiuChuanan on 2019/4/8.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Class newClass = objc_allocateClassPair(objc_getClass("NSObject"), "newClass", 0);
        objc_registerClassPair(newClass);
        id newObject = [[newClass alloc]init];
        NSLog(@"%s",class_getName([newObject class]));
        NSLog(@"Hello, World!");
        
        Person *person = [Person new];
        
        [person name];
        
        [person name];
    }
    return 0;
}
