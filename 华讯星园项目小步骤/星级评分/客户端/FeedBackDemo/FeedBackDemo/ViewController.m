//
//  ViewController.m
//  FeedBackDemo
//
//  Created by Apple on 8/12/15.
//  Copyright (c) 2015 华讯网络投资有限公司. All rights reserved.
//

#import "ViewController.h"
#import "RatingBar.h"
#import "NSString+URLEncoding.h"
#import "singleManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpForDismissKeyboard];
    
    self.title=@"意见反馈";
    [self initView];
    _contentTextView.delegate=self;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;

}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(20, 20, 280, 250)];
    _contentTextView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _contentTextView.layer.borderColor = [[UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0]CGColor];
    
    _contentTextView.layer.borderWidth = 1.0;
    _contentTextView.layer.cornerRadius = 3.0f;
    [_contentTextView.layer setMasksToBounds:YES];
    _contentTextView.scrollEnabled=YES;
    [self.view addSubview:_contentTextView];
    
    _labelPlaceholder=[[UILabel alloc]initWithFrame:CGRectMake(24, 22, 260,30)];
    _labelPlaceholder.text=@"有什么想说的,尽管来吐槽吧~";
    _labelPlaceholder.font=[UIFont fontWithName:@"Helvetica" size:13];
    _labelPlaceholder.enabled=NO;
    _labelPlaceholder.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_labelPlaceholder];
    
    UILabel *starLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 275, 40, 30)];
    starLabel.text=@"星级:";
    starLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
    [self.view addSubview:starLabel];
    
    RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake(starLabel.frame.origin.x+starLabel.frame.size.width, starLabel.frame.origin.y, 180, 30)];
    [self.view addSubview:bar];
    
    
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(20,_contentTextView.frame.origin.y+_contentTextView.frame.size.height+40, 280, 30)];
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    [commit setBackgroundColor:SystemThemeColor];
    
    [commit addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commit];
}

-(void)textViewDidChange:(UITextView *)textView
{
    _contentTextView.text = textView.text;
    if (_contentTextView.text.length == 0) {
        _labelPlaceholder.text = @"有什么想说的,尽管来吐槽吧~";
    }else{
        _labelPlaceholder.text = @"";
    }
}

-(void)buttonAction:(UIButton *)button
{
    [self startRequest];
}


-(void)startRequest
{
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://192.168.40.10/FeedBack/WebService1.asmx"];
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSString * envelopeText = [NSString stringWithFormat:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                               "<soap:Body>"
                               "<feedbackInsertInfo xmlns=\"http://tempuri.org/\">"
                               "<txt>%@</txt>"
                               "<starnum>%d</starnum>"
                               "</feedbackInsertInfo>"
                               "</soap:Body>"
                               "</soap:Envelope>",_contentTextView.text,[singleManager sharedInstance].number];
    
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelope];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    
    if (connection) {
    }
}

#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    
    NSLog(@"%@",[error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    
    NSLog(@"请求完成...");
}

#pragma mark 绑定键盘事件通知
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 创建一个手势识别器
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    //创建操作队列
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    //键盘升起
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];//关键语句，给self.view添加一个手势监测；
                }];
    NSLog(@"键盘升起");
    //键盘降下
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

#pragma mark 点击事件（当点击输入框之外时，收起键盘）
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    NSLog(@"键盘降落");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
