//
//  SlideTittleView.m
//  DynamicController
//
//  Created by 史练练 on 15/9/14.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "SlideTittleView.h"

@interface SlideTittleView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *titlesArray;

@end
@implementation SlideTittleView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {

        self.delegate     = self;
        self.buttonArray  = [NSMutableArray array];
        self.titlesArray  = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.buttonWidth  = frame.size.width / 3.0f;
        self.scale_max    = 1.0f;
        self.scale_min    = 0.8;
        self.gsv_selected = 1.0f;
        self.gsv_default  = 0.8;

    }
    return self;
}


-(void)setupWithTitleArray:(NSArray *)array
{
    self.titlesArray = [NSMutableArray arrayWithArray:array];
    self.buttonArray = [NSMutableArray array];

    self.contentSize = CGSizeMake(self.buttonWidth * (array.count + 2), self.frame.size.height);

    for (int i = 0; i < self.titlesArray.count; i++) {
        [self initButtonsWithTag:i];
    }
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

    //初次设定button，默认第一个按钮为选中状态
    [self clickButton:(UIButton *)[self.buttonArray objectAtIndex:0]];
    [self setButtonStatusWithOffsetX:self.contentOffset.x];
}

#pragma mark  利用KVO检测contentOffset变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self setButtonStatusWithOffsetX:self.contentOffset.x];
    }
}


#pragma mark 设置button样式
-(void)initButtonsWithTag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((tag+1)*self.buttonWidth, 0, self.buttonWidth, self.frame.size.height);
    button.tag = tag;

    [button setTitle:[self.titlesArray objectAtIndex:tag] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:self.gsv_default alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:self.gsv_selected alpha:1] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonArray addObject:button];

    [button setTitleColor:[UIColor colorWithWhite:self.gsv_default alpha:1] forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeScale(self.scale_min, self.scale_min);

    CGPoint center = button.center;
    center.x = (button.tag+1)*self.buttonWidth + self.buttonWidth/2.0f;
    button.center = center;

    [self addSubview:button];
}

#pragma mark  根据偏移量做上下方滚动的联动
-(void)setButtonStatusWithOffsetX:(CGFloat)offsetX
{
    if (offsetX < 0) {
        return;
    }

    if (offsetX > (self.contentSize.width - self.buttonWidth)) {
        return;
    }

    int tempTag = (offsetX/self.buttonWidth);

    if (tempTag > self.titlesArray.count - 2) {
        return;
    }

    for (UIButton *button in self.buttonArray) {
        [button setTitleColor:[UIColor colorWithWhite:self.gsv_default alpha:1] forState:UIControlStateNormal];
        button.transform = CGAffineTransformMakeScale(self.scale_min, self.scale_min);

        CGPoint center = button.center;
        center.x = (button.tag+1)*self.buttonWidth + self.buttonWidth/2.0f;
        button.center = center;
    }

    UIButton *buttonleft    = [self.buttonArray objectAtIndex:tempTag];
    UIButton *buttonRight   = [self.buttonArray objectAtIndex:(tempTag+1)];

    float leftcolorValue = self.gsv_selected - fmod((double)offsetX,self.buttonWidth)/self.buttonWidth*(self.gsv_selected - self.gsv_default);
    float leftScale      = self.scale_max - fmod((double)offsetX,self.buttonWidth)/self.buttonWidth*(self.scale_max - self.scale_min);

    [buttonleft setTitleColor:[UIColor colorWithWhite:(leftcolorValue) alpha:1] forState:UIControlStateNormal];
    buttonleft.transform = CGAffineTransformMakeScale(leftScale, leftScale);

    float rightcolorValue = self.gsv_default + fmod((double)offsetX,self.buttonWidth)/self.buttonWidth;
    float rightScale      = self.scale_min + fmod((double)offsetX,self.buttonWidth)/self.buttonWidth*(self.scale_max - self.scale_min);

    [buttonRight setTitleColor:[UIColor colorWithWhite:(rightcolorValue) alpha:1] forState:UIControlStateNormal];
    buttonRight.transform = CGAffineTransformMakeScale(rightScale, rightScale);

////    修改中心位置
//        CGPoint leftcenter = buttonleft.center;
//        leftcenter.x  = (buttonleft.tag+1)*self.buttonWidth + self.buttonWidth/2.0f;;
//        buttonleft.center = leftcenter;
//    
//        CGPoint rightcenter = buttonRight.center;
//        rightcenter.x = (buttonRight.tag+1)*self.buttonWidth + self.buttonWidth/2.0f;
//        buttonleft.center = rightcenter;
}

- (void)didScollContentOffsetX:(CGFloat)offsetX andPageSizeX:(CGFloat)pagesizex;
{
    NSLog(@"%f ",offsetX/pagesizex);
    [self setContentOffset:CGPointMake((offsetX/pagesizex)*self.buttonWidth, 0)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float temp = (scrollView.contentOffset.x/self.buttonWidth);
    if ((temp >= 0) &&_titleBtnDelegate && [_titleBtnDelegate respondsToSelector:@selector(scrollviewShouldScollByTitleScollview:)]) {
        [_titleBtnDelegate scrollviewShouldScollByTitleScollview:temp];
    }
}

-(void)clickButton:(UIButton *)button
{
    CGFloat left = ((button.tag)*self.buttonWidth);
    [self setContentOffset:CGPointMake(left, 0) animated:YES];

    if (_titleBtnDelegate && [_titleBtnDelegate respondsToSelector:@selector(scrollviewShouldScollByTitleScollview:)]) {
        [_titleBtnDelegate scrollviewShouldScollByTitleScollview:button.tag];
    }
}

#pragma mark 处理scrollview上添加button botton区域无法实现scrollview滑动   
// 重载scrollview的touchesShouldBegin方法 ios8的bug
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    UITouch *touch = [touches anyObject];

    if(touch.phase == UITouchPhaseMoved)
    {
        return NO;
    }
    else
    {
        return [super touchesShouldBegin:touches withEvent:event inContentView:view];
    }
}

-(void)dealloc
{
    self.titleBtnDelegate = nil;
    self.delegate = nil;
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

@end
