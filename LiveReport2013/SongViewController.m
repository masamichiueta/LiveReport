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
@synthesize scrollView=_scrollView;
@synthesize pageControl=_pageControl;
@synthesize songListTable_OK=_songListTable_OK;
@synthesize songListTable_3B=_songListTable_3B;
@synthesize songListTable_19=_songListTable_19;
@synthesize songListTable_SF=_songListTable_SF;
@synthesize liveReportObj = _liveReportObj;
@synthesize artistSelectionSegmentedController = _artistSelectionSegmentedController;


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
    _artistSelectionSegmentedController.tintColor = [UIColor darkGrayColor];
    navBar.roundedCornerRadius = 10;
    
}

#pragma mark -
#pragma mark Initialization
- (void) initTableView {
    _songListTable_OK.delegate = self;
    _songListTable_OK.dataSource = self;
    _songListTable_3B.delegate = self;
    _songListTable_3B.dataSource = self;
    _songListTable_19.delegate = self;
    _songListTable_19.dataSource = self;
    _songListTable_SF.delegate = self;
    _songListTable_SF.dataSource = self;
    
    _songListTable_OK.tag = 0;
    _songListTable_3B.tag = 1;
    _songListTable_19.tag = 2;
    _songListTable_SF.tag = 3;
    
    
    [_songListTable_OK dropShadows];
    [_songListTable_3B dropShadows];
    [_songListTable_19 dropShadows];
    [_songListTable_SF dropShadows];
    _songListTable_OK.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _songListTable_3B.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _songListTable_19.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _songListTable_SF.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
}

- (void) initSongList {
    _liveReportObj = [[LiveReportDAO alloc] init];
    songList_SF = [NSMutableArray array];
    songList_SF = [_liveReportObj getSongList:@"少年フレンド"];
    songList_19 = [NSMutableArray array];
    songList_19 = [_liveReportObj getSongList:@"19"];
    songList_3B = [NSMutableArray array];
    songList_3B = [_liveReportObj getSongList:@"3B LAB.☆S"];
    songList_OK = [NSMutableArray array];
    songList_OK = [_liveReportObj getSongList:@"岡平健治"];
}


#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self customizeNavBar];
    
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    
    [self initTableView];
    [self initSongList];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UIScrollViewController Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = _scrollView.frame.size.width;
    _pageControl.currentPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    _artistSelectionSegmentedController.selectedSegmentIndex = _pageControl.currentPage;
}

#pragma mark -
#pragma mark UISegmentedController Methods
- (IBAction)selectView:(id)sender {
    
    CGPoint point = CGPointMake( 320*_artistSelectionSegmentedController.selectedSegmentIndex,0);
    [_scrollView setContentOffset:point animated:YES];
    
}


#pragma mark -
#pragma mark UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (tableView.tag) {
        case 0:
            return [songList_OK count];
            break;
        case 1:
            return [songList_3B count];
            break;
        case 2:
            return [songList_19 count];
            break;
        case 3:
            return [songList_SF count];
            break;
        default:
            break;
    }
    return 0;
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
    switch (tableView.tag) {
        case 0:
            return [[songList_OK objectAtIndex:section] count];
            break;
        case 1:
            return [[songList_3B objectAtIndex:section] count];
            break;
        case 2:
            return [[songList_19 objectAtIndex:section] count];
            break;
        case 3:
            return [[songList_SF objectAtIndex:section] count];
            break;
        default:
            break;
    }
    return 0;
 
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
    
    switch (tableView.tag) {
        case 0:
            cell.textLabel.text = [[[songList_OK objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            break;
        case 1:
            cell.textLabel.text = [[[songList_3B objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            break;
        case 2:
            cell.textLabel.text = [[[songList_19 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            break;
        case 3:
            cell.textLabel.text = [[[songList_SF objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            break;
        default:
            break;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 0:
            [_songListTable_OK deselectRowAtIndexPath:[_songListTable_OK indexPathForSelectedRow] animated:NO];
            break;
        case 1:
            [_songListTable_OK deselectRowAtIndexPath:[_songListTable_OK indexPathForSelectedRow] animated:NO];
            break;
        case 2:
            [_songListTable_OK deselectRowAtIndexPath:[_songListTable_OK indexPathForSelectedRow] animated:NO];
            break;
        case 3:
            [_songListTable_OK deselectRowAtIndexPath:[_songListTable_OK indexPathForSelectedRow] animated:NO];
            break;
        default:
            break;
    }
}



@end
