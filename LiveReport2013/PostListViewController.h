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


@interface PostListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,EGORefreshTableHeaderDelegate, NSURLConnectionDelegate>{
    
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL reloading;
    NSMutableArray *tweetList;
    NSMutableData* tweetData;
    ImageStore *imageStore;
    
}

@property (strong, nonatomic) IBOutlet UITableView *postListTable;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
