//
//  SongViewController.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/20.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveReportDAO.h"
#import "iAd/iAd.h"

@interface SongViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ADBannerViewDelegate, UIAlertViewDelegate>{
    
    NSMutableArray *songList;
    NSMutableArray *songTableList;
    NSMutableArray *toggleControlList;
    ADBannerView *adBannerView;
    BOOL bannerIsVisible;
    
    int currentTag;
    int currentSection;
    int currentRow;
    

}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) LiveReportDAO *liveReportObj;
;
@property (strong, nonatomic) IBOutlet UISegmentedControl *artistSelectionSegmentedController;
- (IBAction)selectView:(id)sender;


@end
