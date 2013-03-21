//
//  SongViewController.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/20.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "SongViewController.h"

#import "PrettyKit.h"

@interface SongViewController ()

@end

@implementation SongViewController
@synthesize songListTable=_songListTable;
@synthesize liveReportObj = _liveReportObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark Pretty Kit
- (void) customizeNavBar {
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    
    navBar.topLineColor = [UIColor darkGrayColor];
    navBar.gradientStartColor = [UIColor darkGrayColor];
    navBar.gradientEndColor = [UIColor colorWithHex:0x000000];
    navBar.bottomLineColor = [UIColor colorWithHex:0xCC3599];
    navBar.shadowOpacity = 0.0;
    navBar.tintColor = navBar.gradientEndColor;
    navBar.roundedCornerRadius = 10;
    
}


#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self customizeNavBar];
    
    _songListTable.delegate = self;
    _songListTable.dataSource = self;
    
    [_songListTable dropShadows];
    _songListTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    _liveReportObj = [[LiveReportDAO alloc] init];
    songList_SF = [NSMutableArray array];
    songList_SF = [_liveReportObj getSongList:@"少年フレンド"];
    songList_19 = [NSMutableArray array];
    songList_19 = [_liveReportObj getSongList:@"19"];
    songList_3B = [NSMutableArray array];
    songList_3B = [_liveReportObj getSongList:@"3B LAB.☆S"];
    songList_OK = [NSMutableArray array];
    songList_OK = [_liveReportObj getSongList:@"岡平健治"];
    
    // get song number of each album
    rowNumList_SF = [NSMutableArray arrayWithArray:[self getSectionRowNumList:songList_SF]];
    rowNumList_19 = [NSMutableArray arrayWithArray:[self getSectionRowNumList:songList_19]];
    rowNumList_3B = [NSMutableArray arrayWithArray:[self getSectionRowNumList:songList_3B]];
    rowNumList_OK = [NSMutableArray arrayWithArray:[self getSectionRowNumList:songList_OK]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[songList_19 valueForKeyPath:@"@distinctUnionOfObjects.album"] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    //Localize
    switch (section) {
        case 0:{
            NSString* tableHeader = NSLocalizedString(@"Select Set List", @"Select Set List");
            return tableHeader;
            break;
        }
        default:
            break;
    }
    return NULL;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[rowNumList_19 objectAtIndex:section] intValue];
 
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    //PrettyKitSetting
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.minimumScaleFactor = 10;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:10];
    cell.cornerRadius = 5;
    cell.customSeparatorColor = [UIColor colorWithHex:0xCC3599];
    cell.borderColor = [UIColor colorWithHex:0xCC3599];
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    cell.textLabel.text = [[songList_19 objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_songListTable deselectRowAtIndexPath:[_songListTable indexPathForSelectedRow] animated:NO];
}


#pragma mark -
#pragma mark My Methods
-(NSMutableArray *) getSectionRowNumList:(NSMutableArray *)songList{
    
    /*album count algorithm*/
    NSArray *albumList = [songList valueForKeyPath:@"@distinctUnionOfObjects.album"];
    NSMutableArray *rowNumList = [NSMutableArray array];
    for(int i=0; i<[albumList count]; i++){
        int num=0;
        for(int j=0; j<[[songList valueForKey:@"album"] count]; j++){
            if([[albumList objectAtIndex:i] isEqual:[[songList objectAtIndex:j] objectForKey:@"album"]]){
                num ++;
            }
        }
        NSNumber *wrapNum = [NSNumber numberWithInt:num];
        [rowNumList addObject:wrapNum];
        
    }
    return rowNumList;
    
}


@end
