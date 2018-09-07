//
//  ViewController.m
//  LnSlideSelection
//
//  Created by talking on 2018/9/5.
//  Copyright © 2018年 ln. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define MJCommonBgColor [UIColor colorWithRed:241.0/255.0 green:248.0/255.0 blue:255.0/255.0 alpha:1.00f]//controll 背景颜色

#import "ViewController.h"
#import "MJScrollPainView.h"

@interface ViewController ()<MJSelectPainViewDelegate>

@property(nonatomic,strong) MJSelectPainView *scrollPainView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.scrollPainView];
}

#pragma mark MJSelectPainViewDelegate

-(void)didSelectPainLevel:(NSInteger)level{
    NSLog(@"%ld",level);
}


-(MJSelectPainView *)scrollPainView{
    if (!_scrollPainView) {
        _scrollPainView = [[MJSelectPainView alloc]initWithFrame:(CGRectMake(40, 200, kScreenWidth-80,(kScreenWidth-90)/11*2+10))];
        _scrollPainView.backgroundColor = MJCommonBgColor;
        _scrollPainView.delegate = self;
    }
    return _scrollPainView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
