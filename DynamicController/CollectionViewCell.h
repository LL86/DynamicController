//
//  CollectionViewCell.h
//  DynamicController
//
//  Created by 史练练 on 15/9/10.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *cellTable;

@end
