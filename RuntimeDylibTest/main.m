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
        
        
        Person *person = [[Person alloc]init];
//        Person *p2 = person;
//        
//        [person name];
//        [person name];
        
        [person age];
//        Class cls = [Person class];
//        
//        // weak
//        __weak id weakP = person;
//        
//        NSLog(@"weakP point address: %p",&weakP);
//        NSLog(@"person point address: %p",&person);
//        
//        NSLog(@"weakP address: %p",weakP);
        NSLog(@"person address: %p",person);
        
    }
    return 0;
}
