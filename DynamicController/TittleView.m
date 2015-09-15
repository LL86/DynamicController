//
//  TittleView.m
//  DynamicController
//
//  Created by 史练练 on 15/9/14.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "TittleView.h"
#import "SlideTittleView.h"

@interface TittleView()<TitlesInScollViewDelegate>

@end
@implementation TittleView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor darkGrayColor];
        self.tittleArray = [NSArray array];
        [self creatTittleScrollView];
    }
    return self;
}

- (void)creatTittleScrollView{

    self.tittleArray = @[@"高压锅",@"平底锅",@"炒锅",@"帅锅"];
    _titleScrollView = [[SlideTittleView alloc]initWithFrame:CGRectMake(self.frame.size.width/3.0f, 0, self.frame.size.width/3.0f, 40)];

    _titleScrollView.pagingEnabled = YES;
    _titleScrollView.clipsToBounds = NO;
    _titleScrollView.delaysContentTouches = NO;

    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.buttonWidth = self.frame.size.width / 3.0f;
    [_titleScrollView setupWithTitleArray:self.tittleArray];
//    _titleScrollView.backgroundColor = [UIColor darkGrayColor];

    _titleScrollView.titleBtnDelegate = self;
    
    [self addSubview:self.titleScrollView];
}

// 代理回调
-(void)scrollviewShouldScollByTitleScollview:(float)idx
{
    if (_slideTittleDelegate && [_slideTittleDelegate respondsToSelector:@selector(offsetShouldScollByTitleScollview:)]) {

        [_slideTittleDelegate offsetShouldScollByTitleScollview:idx];
    }

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return _titleScrollView;
    }
    return nil;
}


@end
