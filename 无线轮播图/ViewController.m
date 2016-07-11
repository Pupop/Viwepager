//
//  ViewController.m
//  无线轮播图
//
//  Created by YinMingpu on 16/6/3.
//  Copyright © 2016年 YinMingpu. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"

#define kBannerViewHeight 200
@interface ViewController ()<BannerViewDelegate>

{
    BannerView *bannerView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 64, 414, kBannerViewHeight)];
    
    bannerView.sourceArray = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
    
    bannerView.isTimer = YES;
    bannerView.delegate = self;
    
    [self.tableView addSubview:bannerView];
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 414, kBannerViewHeight)];
    self.tableView.tableHeaderView.userInteractionEnabled = NO;
    
    
    
}

-(void)bannerViewClickPage:(NSInteger)clickPage{
    
    NSLog(@"%ld",clickPage);
}


#pragma mark UIScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (scrollView.contentOffset.y<0) {
        
        CGRect initFrame = bannerView.frame;
        initFrame.origin.y = scrollView.contentOffset.y;
        
        initFrame.size.height = kBannerViewHeight-scrollView.contentOffset.y;
        bannerView.frame = initFrame;
        
    }
    
}



@end
