//
//  ViewController.m
//  MTTRuntime
//
//  Created by LiuChuanan on 2019/4/8.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *valueString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (u_int i = 0; i < count; i++) {
        const char * propertyName = property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    
    NSLog(@"%@",propertiesArray);
}


@end
