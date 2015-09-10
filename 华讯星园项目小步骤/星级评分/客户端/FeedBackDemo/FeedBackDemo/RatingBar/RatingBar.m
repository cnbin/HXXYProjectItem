//
//  RatingBar.m
//  MyRatingBar
//
//  Created by Apple on 11/18/14.
//  Copyright (c) 2014 华讯网络投资有限公司. All rights reserved.

#import "RatingBar.h"
#define ZOOM 0.8f
@interface RatingBar()
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,assign) CGFloat starWidth;
@end

@implementation RatingBar

- (id)initWithFrame:(CGRect)frame
{
    //在子类中重载initWithFrame方法，必须先调用父类的initWithFrame方法
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.bottomView = [[UIView alloc] initWithFrame:self.bounds];
        self.topView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:self.bottomView];
        [self addSubview:self.topView];
        
        self.topView.clipsToBounds = YES;
        self.topView.userInteractionEnabled = NO;
        self.bottomView.userInteractionEnabled = NO;
        self.userInteractionEnabled = YES;
        
        //点一下
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        //拖移，慢速移动
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:pan];
        
  
        CGFloat width = frame.size.width/7.0;
        self.starWidth = width;
        //i表示多少个星星,改变星星数目通过改变i
        for(int i = 0;i<5;i++){
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width*ZOOM, width*ZOOM)];
           // center属性指的是这个ImageView的中间点。
            img.center = CGPointMake((i+1.5)*width, frame.size.height/2);
            img.image = [UIImage imageNamed:@"bt_star_a"];
            [self.bottomView addSubview:img];
            UIImageView *img2 = [[UIImageView alloc] initWithFrame:img.frame];
            img2.center = img.center;
            img2.image = [UIImage imageNamed:@"bt_star_b"];
            [self.topView addSubview:img2];
        }
        self.enable = YES;
        
    }
    return self;
}
//设置set方法,View都设置为白色
-(void)setViewColor:(UIColor *)backgroundColor{
    if(_viewColor!=backgroundColor){
        self.backgroundColor = backgroundColor;
        self.topView.backgroundColor = backgroundColor;
        self.bottomView.backgroundColor = backgroundColor;
    }
}
//设置set方法
-(void)setStarNumber:(NSInteger)starNumber{
    if(_starNumber!=starNumber){
        _starNumber = starNumber;
        self.topView.frame = CGRectMake(0, 0, self.starWidth*(starNumber+1), self.bounds.size.height);
    }
}
//tap事件
-(void)tap:(UITapGestureRecognizer *)gesture{
       
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (int)(point.x/self.starWidth)+1;
        self.topView.frame = CGRectMake(0, 0, self.starWidth*count, self.bounds.size.height);
        if(count>5){
            _starNumber = 5;
        }else{
            _starNumber = count-1;
        }
    }
    NSLog(@"the tap_starNumber星星数目 is %ld",(long)_starNumber);
    
    [singleManager sharedInstance].number=(long)_starNumber;
}
//pan事件
-(void)pan:(UIPanGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (int)(point.x/self.starWidth);
        if(count>=0 && count<=5 && _starNumber!=count){
            self.topView.frame = CGRectMake(0, 0, self.starWidth*(count+1), self.bounds.size.height);
            _starNumber = count;
    
        }
    }
    NSLog(@"the pan_starNumber is %ld",(long)_starNumber);
     [singleManager sharedInstance].number=(long)_starNumber;
}


@end
