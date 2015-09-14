//
//  ViewController.m
//  DynamicController
//
//  Created by 史练练 on 15/9/10.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "ViewController.h"
#import "SlideTittleView.h"
#import "CollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,TitlesInScollViewDelegate>

// 上方滑动分页栏
@property (nonatomic, strong) SlideTittleView *titleScrollView;

//滑动子控制器数组
@property (nonatomic, strong) NSArray *tittleArray;

//下方滑动的列表
@property (nonatomic, strong) UICollectionView *slideCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tittleArray = [NSArray array];

    self.navigationItem.title = @"锅具";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 上方滑动分页栏
    [self initSlideTittleView];

    // 下方滑动列表
    [self setUpslideCollectionViewList];

}

#pragma mark  上方滑动分页栏
- (void)initSlideTittleView{

     self.tittleArray = @[@"高压锅",@"平底锅",@"炒锅",@"帅锅"];
    _titleScrollView = [[SlideTittleView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    _titleScrollView.pagingEnabled = YES;

        // 处理scrollview上添加button botton区域无法实现scrollview滑动
    _titleScrollView.panGestureRecognizer.delaysTouchesBegan = YES;

    _titleScrollView.buttonWidth = self.view.frame.size.width / 3.0f;
    [_titleScrollView setupWithTitleArray:self.tittleArray];
    _titleScrollView.backgroundColor = [UIColor darkGrayColor];

    _titleScrollView.titleBtnDelegate = self;

    [self.view addSubview:_titleScrollView];
}


#pragma mark  下方滑动collectionView
- (void)setUpslideCollectionViewList{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    /**
     *  PS：minimumInterItemSpacing FlowLayout默认的是25 (处理item之间间距默认距离)
     */
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    // 40、64 分别为上方滑动选择器和导航高度
    self.slideCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40 + 64, self.view.frame.size.width, self.view.frame.size.height - 40 - 64)
                                                  collectionViewLayout:flowLayout];

    self.slideCollectionView.delegate = self;
    self.slideCollectionView.dataSource = self;

    self.slideCollectionView.backgroundColor = [UIColor whiteColor];
    self.slideCollectionView.pagingEnabled = YES;
    self.slideCollectionView.showsHorizontalScrollIndicator = NO;

    [self.slideCollectionView registerClass:[CollectionViewCell class]
                 forCellWithReuseIdentifier:@"reuseIdentifier"];

    [self.view addSubview:self.slideCollectionView];
}

#pragma mark -- UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tittleArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{




    CollectionViewCell * cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];


        return cell;
}

#pragma mark --UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{


    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 40 - 64);

}



#pragma mark --UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{


        NSLog(@"slideList %ld被选中了",(long)indexPath.row);
}

#pragma mark 利用代理检测scrollView滑动距离   关联上下方的滚动.
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_titleScrollView didScollContentOffsetX:scrollView.contentOffset.x andPageSizeX:self.view.frame.size.width];
}

// 代理回调
-(void)scrollviewShouldScollByTitleScollview:(float)Xpercent
{
    [self.slideCollectionView setContentOffset:CGPointMake(Xpercent*self.view.frame.size.width, 0) animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
