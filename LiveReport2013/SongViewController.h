//
//  SongViewController.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/20.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveReportDAO.h"

@interface SongViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>{
    
    NSMutableArray *songList;
    NSMutableArray *songTableList;
    NSMutableArray *toggleControlList;
    
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
