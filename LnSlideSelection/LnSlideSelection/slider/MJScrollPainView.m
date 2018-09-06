//
//  MJScrollPainView.m
//  MagiKarePatient
//
//  Created by talking on 2017/12/26.
//  Copyright © 2017年 李宁. All rights reserved.
//

#define MJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define MJWhiteColor [UIColor whiteColor]//白色

#import "MJScrollPainView.h"

#import "UIView+YYAdd.h"

@implementation MJScrollPainView



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    
    NSArray *colorArr = @[MJColor(177, 225, 255),MJColor(146, 244, 211),MJColor(135, 219, 145),MJColor(215, 236, 72),MJColor(238, 189, 48),MJColor(230, 182, 46),MJColor(248, 157, 41),MJColor(246, 109, 47),MJColor(252, 81, 41),MJColor(252, 39, 71),MJColor(235, 0, 16)];
    
    for (int i=0; i<11; i++) {
        UIColor *color = colorArr[i];
        [color set];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:(CGRectMake(i*self.width/11, 0, self.width/11, self.width/11))];
        [path fill];
        NSString *string = [NSString stringWithFormat:@"%d",i];
        [string drawAtPoint:CGPointMake(self.width/11*i+self.width/22-5, self.width/22-8) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }

    
    
}

@end

@interface MJSelectPainView()<UIGestureRecognizerDelegate>


@end

@implementation MJSelectPainView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    self.bgWhiteView.frame = CGRectMake(0, self.height/2-((self.width-10)/11+10)/2, self.width, (self.width-10)/11+10);
    [self.bgWhiteView addSubview:self.scrollView];
    [self addSubview:self.currentPainView];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] init];
    pan.delegate = self;
    [self.currentPainView addGestureRecognizer:pan];
    [pan addTarget:self action:@selector(panAction:)];
}

-(void)panAction:(UIPanGestureRecognizer *)pan{
    
    BOOL  _canLeft = YES;
    
    BOOL   _canRight = YES;
    
     NSArray *colorArr = @[MJColor(177, 225, 255),MJColor(146, 244, 211),MJColor(135, 219, 145),MJColor(215, 236, 72),MJColor(238, 189, 48),MJColor(230, 182, 46),MJColor(248, 157, 41),MJColor(246, 109, 47),MJColor(252, 81, 41),MJColor(252, 39, 71),MJColor(235, 0, 16)];
    
    //点相对于上一个点的位置
    
    CGPoint moviePoint = [pan translationInView:pan.view];
    
    //点的速度(正负可判断滑动趋势)
    
//    CGPoint velocity = [pan velocityInView:pan.view];
 
    //侧滑的范围
    
    CGFloat instance = self.scrollView.width-self.scrollView.width/11;
    
    
    //禁止左划的情况(在最左边时)
    
    if (pan.view.left <= 0) {
//        NSLog(@"&&&&&&%f",pan.view.left);
        _canLeft = NO;
        
    }
    //禁止右划得情况(在最右边时)
    
    if (pan.view.left-5 > instance) {
        
        _canRight = NO;
        
    }
//    NSLog(@"%f----%f",pan.view.left,moviePoint.x);

    //页面可以滑动的条件
    
    if (_canRight && _canLeft && pan.view.left >= 0 && pan.view.left-5 <= instance){
        
        //移动
        
        pan.view.center = CGPointMake(pan.view.center.x + moviePoint.x, pan.view.center.y);
        
        
    }
    
    //每次都需要复位
    
    [pan setTranslation:CGPointZero inView:pan.view];
    
    //松开手指时判断滑动趋势让其归位
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        NSInteger index;
        if (pan.view.left <= 5) {

            pan.view.left = 5;
            index = 0;
            self.currentPainView.levelLabel.text = @"0";
            self.currentPainView.levelLabel.backgroundColor = colorArr[0];
            self.currentPainView.tipView.backgroundColor = colorArr[0];
        }else if(pan.view.left > instance){

            pan.view.left = instance+5;
            index = 10;
            self.currentPainView.levelLabel.text = @"10";
            self.currentPainView.levelLabel.backgroundColor = colorArr[10];
            self.currentPainView.tipView.backgroundColor = colorArr[10];

        }else{
            extern double round(double);
            CGFloat value =  (pan.view.left-5)/(self.scrollView.width/11);
            index = round(value);
            pan.view.left = 5+index*(self.scrollView.width/11);
            self.currentPainView.levelLabel.text = [NSString stringWithFormat:@"%ld",index];
            self.currentPainView.levelLabel.backgroundColor = colorArr[index];
            self.currentPainView.tipView.backgroundColor = colorArr[index];
        }
        
        if ([self.delegate respondsToSelector:@selector(didSelectPainLevel:)]) {
            [self.delegate didSelectPainLevel:index];
        }
        
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        extern double round(double);
        CGFloat value =  (pan.view.left-5)/(self.scrollView.width/11);
        NSInteger index = round(value);
        if (index == 11) {//防止出现四舍五入等于11造成数组越界的问题
            index = 10;
        }else if (index == -1){
            index = 0;
        }
        self.currentPainView.levelLabel.text = [NSString stringWithFormat:@"%ld",index];
        self.currentPainView.levelLabel.backgroundColor = colorArr[index];
        self.currentPainView.tipView.backgroundColor = colorArr[index];
        NSLog(@"%ld",index);
    }

}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    NSLog(@"translation == %f", translation.x);
    //    if (translation.x >= 0) {
    //        return NO;
    //    }
    return YES;
}

#pragma mark lazyLoad
-(MJScrollPainView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[MJScrollPainView alloc]initWithFrame:(CGRectMake(5, 5, self.width-10, (self.width-10)/11))];
        _scrollView.layer.masksToBounds = YES;
        _scrollView.layer.cornerRadius = (self.width-10)/22;
        _scrollView.backgroundColor = MJWhiteColor;
    }
    return _scrollView;
}
-(UIView *)bgWhiteView{
    if (!_bgWhiteView) {
        _bgWhiteView = [[UIView alloc]init];
        _bgWhiteView.backgroundColor = MJWhiteColor;
        _bgWhiteView.layer.masksToBounds = YES;
        _bgWhiteView.layer.cornerRadius =((self.width-10)/11+10)/2;
        [self addSubview:_bgWhiteView];
    }
    return _bgWhiteView;
}
-(MJPainCurrentLevelView *)currentPainView{
    if (!_currentPainView) {
        _currentPainView = [[MJPainCurrentLevelView  alloc]initWithFrame:(CGRectMake(5, 0, (self.width-10)/11, self.height))];
        _currentPainView.backgroundColor = MJWhiteColor;
        _currentPainView.layer.masksToBounds = YES;
        _currentPainView.layer.cornerRadius = (self.width-10)/22;
        _currentPainView.layer.borderWidth = 1.0f;
        _currentPainView.layer.borderColor = MJColor(91, 205, 167).CGColor;
    }
    return _currentPainView;
}

@end

@implementation MJPainCurrentLevelView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    self.levelLabel.frame = CGRectMake(5, 5, self.width-10, self.width-10);
    self.tipView.frame  = CGRectMake(self.width/2-4, self.width, 8, 8);
    self.imageView.frame = CGRectMake(8, self.height+5-self.width, self.width-16, self.width-16);
}

#pragma mark lazyLoad
-(UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc]init];
        _levelLabel.text = @"0";
        _levelLabel.backgroundColor = MJColor(177, 225, 255);
        _levelLabel.layer.masksToBounds = YES;
        _levelLabel.layer.cornerRadius = (self.width-10)/2;
        _levelLabel.font = [UIFont systemFontOfSize:10];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.textColor = MJWhiteColor;
        [self addSubview:_levelLabel];
    }
    return _levelLabel;
}
-(UIView *)tipView{
    if (!_tipView) {
        _tipView = [[UIView alloc]init];
        _tipView.layer.masksToBounds = YES;
        _tipView.layer.cornerRadius = 4;
        _tipView.backgroundColor = MJColor(177, 225, 255);
        [self addSubview:_tipView];
    }
    return _tipView;
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
//        _imageView.backgroundColor = MJBlueColor;
        _imageView.image = [UIImage imageNamed:@"drag"];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

@end

