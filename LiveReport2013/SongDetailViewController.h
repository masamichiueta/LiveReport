//
//  SongDetailViewController.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/28.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAd/iAd.h"

@interface SongDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, ADBannerViewDelegate>{
    
    ADBannerView *adBannerView;
    BOOL bannerIsVisible;
}

@property (strong, nonatomic) IBOutlet UITableView *songDetailTable;

@property (strong, nonatomic) NSString *songName;
@property (strong, nonatomic) NSString *albumName;
@property (strong, nonatomic) NSString *albumPic;
@property (strong, nonatomic) NSString *itunesLink;

@end
