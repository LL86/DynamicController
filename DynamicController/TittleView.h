//
//  TittleView.h
//  DynamicController
//
//  Created by 史练练 on 15/9/14.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlideTittleView;

@protocol ScrollViewInViewDelegate <NSObject>

- (void)offsetShouldScollByTitleScollview:(float)offset;

@end

@interface TittleView : UIView

@property (nonatomic, strong) SlideTittleView *titleScrollView;
@property (nonatomic, strong) NSArray *tittleArray;


@property (nonatomic, assign) id<ScrollViewInViewDelegate>slideTittleDelegate;

@end
