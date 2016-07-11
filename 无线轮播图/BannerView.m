//
//  BannerView.m
//  无线轮播图
//
//  Created by YinMingpu on 16/6/3.
//  Copyright © 2016年 YinMingpu. All rights reserved.
//

#import "BannerView.h"
#define kMaxSection 100
#define kNoTouchTime 3.0
#define kTimeInterval 3.0

@interface BannerView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *layout;
    UIPageControl *pageControl;
    NSTimer *timer;
}

@end


@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setCollectView:frame];
        [self setPageControl:frame];
        
    }
    return self;
}

-(void)setPageControl:(CGRect)frame{
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
    pageControl.backgroundColor = [UIColor cyanColor];
    [self addSubview:pageControl];
}

-(void)setCollectView:(CGRect)frame{
    
    
    layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_collectionView addGestureRecognizer:tap];
    
}


-(void)tap{
    
    
    if ([self.delegate respondsToSelector:@selector(bannerViewClickPage:)]) {
        
        [self.delegate bannerViewClickPage:pageControl.currentPage];
    }
    
}

#pragma mark UICollectoin delegate datasource delegatelayout

//一百段
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return kMaxSection ;
}

//每段count行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.sourceArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    /*
    //可以自定义cell
//    cell.backgroundColor = [UIColor greenColor];
    
//    UILabel *label = [[UILabel alloc]init];
//    label.text = _sourceArray[indexPath.item];
    
//    label.font = [UIFont systemFontOfSize:20];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor redColor];
//    cell.backgroundView = label;
    */
    
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.sourceArray[indexPath.item]]];
    return cell;
}

//给数据源赋值时调用
-(void)setSourceArray:(NSArray *)sourceArray{
    
    _sourceArray = sourceArray;
    pageControl.numberOfPages = self.sourceArray.count;
    [_collectionView reloadData];
    //来到当前页面中间
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:kMaxSection/2] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

//继承于scrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    int page = (int)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.sourceArray.count;
    pageControl.currentPage = page;
    
}

-(void)setIsTimer:(BOOL )isTimer{
    
    _isTimer = isTimer;
    
    if (_isTimer == YES) {
        timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
    
}

-(void)nextPage{
    
    //获取到当前可见的最后一张试图
    NSIndexPath *currentIndexPath = [_collectionView.indexPathsForVisibleItems lastObject];
    NSIndexPath *currentIndexReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:kMaxSection/2];
    //返回到中间的一段重复用这个Section,从上一个段落返回不用动画效果。
    [_collectionView scrollToItemAtIndexPath:currentIndexReset atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    //准备下一个item
    NSInteger nextItem = currentIndexPath.item+1;
    //准备下一个section
    NSInteger nextSection = currentIndexReset.section;
    if (nextItem == self.sourceArray.count) {
        
        nextSection ++;
        nextItem = 0;
    }
    
    NSIndexPath *nextIndexReset = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    //来到
    [_collectionView scrollToItemAtIndexPath:nextIndexReset atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    
}

//触摸让轮播暂停几秒
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //触摸定时器停止
    timer.fireDate = [NSDate distantFuture];
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //kNoTouchTime秒后让定时器再启动
    timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:kNoTouchTime];
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    _collectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    layout.itemSize = frame.size;
    
    pageControl.frame = CGRectMake(0, frame.size.height-20, frame.size.width, 20);
    
    [_collectionView reloadData];
}


- (void)dealloc{
    
    [timer invalidate];
    
    timer = nil;
}



@end
