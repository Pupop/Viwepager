//
//  BannerView.h
//  无线轮播图
//
//  Created by YinMingpu on 16/6/3.
//  Copyright © 2016年 YinMingpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerViewDelegate <NSObject>

//准协议挂代理及方法
-(void)bannerViewClickPage:(NSInteger)clickPage;

@end


@interface BannerView : UIView

@property (nonatomic,weak) id<BannerViewDelegate> delegate;

@property(nonatomic,strong)NSArray *sourceArray;

//是否需要定时轮播
@property(nonatomic,assign)BOOL isTimer;



@end
/*


//#pragma mark UIScrollView
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    
//    if (scrollView.contentOffset.y<0) {
//        
//        CGRect initFrame = bannerView.frame;
//        initFrame.origin.y = scrollView.contentOffset.y;
//        
//        initFrame.size.height = 200-scrollView.contentOffset.y;
//        bannerView.frame = initFrame;
//        
//    }
//    
//}


*/




