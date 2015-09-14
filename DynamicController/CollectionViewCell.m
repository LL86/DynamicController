//
//  CollectionViewCell.m
//  DynamicController
//
//  Created by 史练练 on 15/9/10.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "CollectionViewCell.h"
#import "CellItem.h"

@implementation CollectionViewCell

/**
 *  该cell 盛放一个tableView
 */

- (instancetype)initWithFrame:(CGRect)frame{

     self = [super initWithFrame:frame];

    if (self) {
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.backgroundColor = [UIColor whiteColor];

        [self setUpTableView];
    }
    return self;
}

#pragma mark  cell上放置的UItableView
- (void)setUpTableView{

    self.cellTable = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];

    self.cellTable.delegate = self;
    self.cellTable.dataSource = self;

    UINib *nib = [UINib nibWithNibName:@"CellItem" bundle:nil];
    [self.cellTable registerNib:nib forCellReuseIdentifier:@"Identifier"];

    self.cellTable.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.cellTable];
}

#pragma mark  UITableViewDelegate UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 130;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CellItem *tableCell = [tableView dequeueReusableCellWithIdentifier:@"Identifier" forIndexPath:indexPath];
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return tableCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%ld进入详情页面",(long)indexPath.row);
}

 
@end
