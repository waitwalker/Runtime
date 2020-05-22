//
//  MTTBlockManager.h
//  MTTRuntime
//
//  Created by etiantian on 2020/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CallBack)(NSDictionary *parameter);

@interface MTTBlockManager : NSObject

@property (nonatomic, copy) CallBack myCallBack;

+ (void)nameWithCallBack:(CallBack)callBack;

@end

NS_ASSUME_NONNULL_END
