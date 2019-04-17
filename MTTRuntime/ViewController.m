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
    
    // 静态局部变量
    static int valueOne = 10;
    
    
    // MARK: - 截获静态变量,全局变量
    void(^BlockOne)(void) = ^void(){
        valueOne = 1;
        valueTwo = 2;
        valueThree = 3;
        NSLog(@"valueOne:%d,valueTwo:%d,valueThree:%d",valueOne,valueTwo,valueThree);
        
    };
    
    // 修改自动变量的值
    valueOne = 9;
    
    // 调用block
    BlockOne();
    
}


@end
