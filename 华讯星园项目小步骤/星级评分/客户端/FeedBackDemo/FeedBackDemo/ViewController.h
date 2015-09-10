//
//  ViewController.h
//  FeedBackDemo
//
//  Created by Apple on 8/12/15.
//  Copyright (c) 2015 华讯网络投资有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SystemThemeColor [UIColor colorWithRed:0 green:199.0f/255.0f blue:140.0f/255.0f alpha:1.0f]
@interface ViewController : UIViewController<UITextViewDelegate,NSXMLParserDelegate,NSURLConnectionDelegate>

@property (nonatomic,strong) UILabel * labelPlaceholder;
@property (nonatomic,strong) UITextView *contentTextView;
@end


