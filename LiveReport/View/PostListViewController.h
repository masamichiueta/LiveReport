//
//  PostListViewController.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/28.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "ImageStore.h"
#import "iAd/iAd.h"


@interface PostListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,EGORefreshTableHeaderDelegate, NSURLConnectionDelegate, ADBannerViewDelegate>{
    
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL reloading;
    NSMutableArray *tweetList;
    //NSMutableData* tweetData;
    ImageStore *imageStore;
    ADBannerView *adBannerView;
    BOOL bannerIsVisible;
    
}

@property (strong, nonatomic) IBOutlet UITableView *postListTable;
@property (strong, nonatomic) NSString *accountId;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
