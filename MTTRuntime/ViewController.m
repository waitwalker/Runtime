//
//  ViewController.m
//  MTTRuntime
//
//  Created by LiuChuanan on 2019/4/8.
//

#import "ViewController.h"

// 静态全局变量
static int valueTwo = 20;

// 全局变量
int valueThree = 30;

@interface ViewController ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *valueString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // __block修饰的自动变量
    __block int valueOne = 10;
    
    
    // MARK: - 截获__block修饰的自动变量
    void(^BlockOne)(void) = ^void(){
        valueOne = 1;
        NSLog(@"valueOne:%d",valueOne);
        
    };
    
    // 修改自动变量的值
    valueOne = 9;
    
    // 调用block
    BlockOne();
    
    // autoreleasepool
    @autoreleasepool {
        
    }
    
}


@end
