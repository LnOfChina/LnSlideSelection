//
//  MJScrollPainView.h
//  MagiKarePatient
//
//  Created by talking on 2017/12/26.
//  Copyright © 2017年 李宁. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJPainCurrentLevelView;
@interface MJScrollPainView : UIView

@end

@protocol MJSelectPainViewDelegate<NSObject>

-(void)didSelectPainLevel:(NSInteger )level;
@end
@interface  MJSelectPainView :UIView

@property(nonatomic,strong) MJScrollPainView *scrollView;

@property(nonatomic,strong) UIView *bgWhiteView;

@property(nonatomic,strong) MJPainCurrentLevelView *currentPainView;

@property(nonatomic,assign) BOOL  shoudRespondDelelegate;

@property(nonatomic,assign) id<MJSelectPainViewDelegate>  delegate;

@end

@interface MJPainCurrentLevelView :UIView

@property(nonatomic,strong) UILabel *levelLabel;

@property(nonatomic,strong) UIView *tipView;


@property(nonatomic,strong) UIImageView *imageView;

@end
