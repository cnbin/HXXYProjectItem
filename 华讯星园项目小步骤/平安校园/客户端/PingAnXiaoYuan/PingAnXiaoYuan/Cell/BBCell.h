//
//  BBCell.h
//  PingAnXiaoYuan
//
//  Created by Apple on 9/10/15.
//  Copyright (c) 2015 广东华讯网络投资有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface BBCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *GradeName;

@property (strong, nonatomic) IBOutlet UILabel *ClassesName;
@property (strong, nonatomic) IBOutlet UILabel *StudentName;
@property (strong, nonatomic) IBOutlet UILabel *InOut;

@property (strong, nonatomic) IBOutlet UILabel *Date;

@end
