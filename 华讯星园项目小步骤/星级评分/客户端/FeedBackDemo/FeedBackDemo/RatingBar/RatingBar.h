//
//  RatingBar.h
//  MyRatingBar
//
//  Created by Apple on 11/18/14.
//  Copyright (c) 2014 华讯网络投资有限公司. All rights reserved.

#import <UIKit/UIKit.h>
#import "singleManager.h"
@interface RatingBar : UIView
@property (nonatomic,assign) NSInteger starNumber;
/*
 *调整底部视图的颜色
 */
@property (nonatomic,strong) UIColor *viewColor;

/*
 *是否允许可触摸
 */
@property (nonatomic,assign) BOOL enable;
@end
