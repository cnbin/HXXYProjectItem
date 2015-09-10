//
//  singleManager.h
//  GetListDemo
//
//  Created by Apple on 8/4/15.
//  Copyright (c) 2015 华讯网络投资有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface singleManager : NSObject
@property (nonatomic,assign)  NSInteger * number;
+ (instancetype)sharedInstance;
@end
