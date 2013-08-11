//
//  SongViewController.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/20.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "SongViewController.h"
#import "SongDetailViewController.h"

#import "SongToggleControl.h"
#import "ImageUtil.h"
#import "PostInfoUtil.h"

#import "PrettyKit.h"

@interface SongViewController ()

@end

@implementation SongViewController
@synthesize scrollView=_scrollView;
@synthesize pageControl=_pageControl;
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
#pragma mark Rotation

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)FromInterfaceOrientation {
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * _pageControl.currentPage, 0);
    for(int i=0; i<[songTableList count]; i++){
        UITableView *songTable = [songTableList objectAtIndex:i];
        songTable.frame = CGRectMake(_scrollView.bounds.size.width*i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }
     _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*ARTIST_NUM, _scrollView.frame.size.height);
    
    if(bannerIsVisible){
        adBannerView.frame = CGRectMake(adBannerView.frame.origin.x, adBannerView.frame.origin.y, self.view.frame.size.width, adBannerView.frame.size.height);
        for(UITableView *songTable in songTableList){
            songTable.frame = CGRectMake(songTable.frame.origin.x, songTable.frame.origin.y + adBannerView.frame.size.height, songTable.frame.size.width, songTable.frame.size.height - adBannerView.frame.size.height);
        }
    }
    else{
        for(UITableView *songTable in songTableList){
            songTable.frame = CGRectMake(songTable.frame.origin.x, 0, songTable.frame.size.width,  self.view.frame.size.height);
        }
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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

- (void) initSongList {
    _liveReportObj = [[LiveReportDAO alloc] init];
    
    songList = [NSMutableArray array];
    
    NSMutableArray* songList_OK = [NSMutableArray arrayWithArray:[_liveReportObj getSongListByArtist:@"岡平健治"]];
    NSMutableArray* songList_3B = [NSMutableArray arrayWithArray:[_liveReportObj getSongListByArtist:@"3B LAB.☆S"]];
    NSMutableArray* songList_19 = [NSMutableArray arrayWithArray:[_liveReportObj getSongListByArtist:@"19"]];
    NSMutableArray* songList_SF = [NSMutableArray arrayWithArray:[_liveReportObj getSongListByArtist:@"少年フレンド"]];
    [songList addObject:songList_OK];
    [songList addObject:songList_3B];
    [songList addObject:songList_19];
    [songList addObject:songList_SF];
}

-(void) initToggleControl{
    toggleControlList = [NSMutableArray array];
    
    for(int i=0;i<[songList count];i++){
        NSMutableArray* toggleControlList_section = [NSMutableArray array];
        for(int j=0;j<[[songList objectAtIndex:i] count]; j++){
            NSMutableArray* toggleControlList_row = [NSMutableArray array];
            for(int k=0;k<[[[songList objectAtIndex:i] objectAtIndex:j] count]; k++){
                SongToggleControl *toggleControl = [[SongToggleControl alloc] initWithFrame: CGRectMake(0,0,60,60)];
                toggleControl.tag = i;
                toggleControl.section = j;
                toggleControl.row = k;
                toggleControl.songName = [[[[songList objectAtIndex:i] objectAtIndex:j] objectAtIndex:k] objectForKey:@"name"];
                [toggleControlList_row addObject:toggleControl];
            }
            [toggleControlList_section addObject:toggleControlList_row];
        }
        [toggleControlList addObject:toggleControlList_section];
    }
    //Register NC in SongToggleControl
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(songTogglePushed:) name:@"SongTogglePushed" object:nil];
}

- (void) initScrollView{
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*ARTIST_NUM, _scrollView.frame.size.height);
}


- (void) initTableView {
    
    songTableList = [NSMutableArray array];
    for(int i=0; i<ARTIST_NUM; i++){
        
        UITableView *songTable = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width*i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) style:UITableViewStyleGrouped];
        
        songTable.delegate = self;
        songTable.dataSource = self;
        songTable.tag = i;
        [songTable dropShadows];
        songTable.backgroundView = nil;
        songTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        [songTableList addObject:songTable];
        [_scrollView addSubview:songTable];
    }
}

-(void) initIAd{
    adBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    adBannerView.delegate = self;
    adBannerView.frame = CGRectOffset(adBannerView.frame, 0.0, -adBannerView.frame.size.height);
    bannerIsVisible=NO;
    [self.view addSubview:adBannerView];
}



#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeNavBar];
    [self initSongList];
    [self initToggleControl];
    [self initIAd];

}


//For AutoLayout of ScrollView ( viewDidLoad does not load scrollview)
- (void) viewDidAppear:(BOOL)animated{
    if([songTableList count] == 0){
        [self initScrollView];
        [self initTableView];
    }
    
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * _pageControl.currentPage, 0);
    for(int i=0; i<[songTableList count]; i++){
        UITableView *songTable = [songTableList objectAtIndex:i];
        songTable.frame = CGRectMake(_scrollView.bounds.size.width*i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*ARTIST_NUM, _scrollView.frame.size.height);
    

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
    
    CGPoint point = CGPointMake( _scrollView.frame.size.width*_artistSelectionSegmentedController.selectedSegmentIndex,0);
    [_scrollView setContentOffset:point animated:YES];
    
}


#pragma mark -
#pragma mark UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (tableView.tag) {
        case 0:
            return [[songList objectAtIndex:0] count] + 1;
            break;
        case 1:
            return [[songList objectAtIndex:1] count];
            break;
        case 2:
            return [[songList objectAtIndex:2] count];
            break;
        case 3:
            return [[songList objectAtIndex:3] count];
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
        case 0:{
            switch (section) {
                case 0:
                    return 1;
                    break;
                    
                default:
                    return [[[songList objectAtIndex:0] objectAtIndex:section - 1] count];
                    break;
            }
        }
            break;
        case 1:
            return [[[songList objectAtIndex:1] objectAtIndex:section] count];
            break;
        case 2:
            return [[[songList objectAtIndex:2] objectAtIndex:section] count];
            break;
        case 3:
            return [[[songList objectAtIndex:3] objectAtIndex:section] count];
            break;
        default:
            break;
    }
    return 0;
 
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 0 && indexPath.section == 0){
        static NSString *CellIdentifier = @"ResetCell";
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
        cell.textLabel.text = NSLocalizedString(@"Reset SetList", @"Reset Set List");
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        
        PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.tableViewBackgroundColor = tableView.backgroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
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
        
    
        //Cell Accessory 
        UIButton *myAccessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [myAccessoryButton setBackgroundColor:[UIColor clearColor]];
        [myAccessoryButton setImage:[UIImage imageNamed:@"custom_accessory"] forState:UIControlStateNormal];
        [myAccessoryButton setImage:[UIImage imageNamed:@"custom_accessory_touched"] forState:UIControlStateHighlighted];
        [myAccessoryButton addTarget:self action:@selector(myAccessoryTouched:event:)forControlEvents:UIControlEventTouchUpInside];
        [cell setAccessoryView:myAccessoryButton];
        
        
        //Cell Content
        switch (tableView.tag) {
            case 0:
                cell.textLabel.text = [[[[songList objectAtIndex:0] objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row] objectForKey:@"name"];
                //Check Mark
                cell.imageView.image = [ImageUtil imageWithColor:[UIColor clearColor]];
                [cell.contentView addSubview:[[[toggleControlList objectAtIndex:tableView.tag] objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row]];
                break;
            case 1:
                cell.textLabel.text = [[[[songList objectAtIndex:1] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
                //Check Mark
                cell.imageView.image = [ImageUtil imageWithColor:[UIColor clearColor]];
                [cell.contentView addSubview:[[[toggleControlList objectAtIndex:tableView.tag] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
                break;
            case 2:
                cell.textLabel.text = [[[[songList objectAtIndex:2] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
                //Check Mark
                cell.imageView.image = [ImageUtil imageWithColor:[UIColor clearColor]];
                [cell.contentView addSubview:[[[toggleControlList objectAtIndex:tableView.tag] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
                break;
            case 3:
                cell.textLabel.text = [[[[songList objectAtIndex:3] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
                //Check Mark
                cell.imageView.image = [ImageUtil imageWithColor:[UIColor clearColor]];
                [cell.contentView addSubview:[[[toggleControlList objectAtIndex:tableView.tag] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
                break;
            default:
                break;
        }
        return cell;
    }
    
    
    
}

-(void)myAccessoryTouched:(id)sender event:(id)event{
    NSLog(@"tapped");
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
    switch (_pageControl.currentPage) {
        case 0:{
            CGPoint currentTouchPosition = [touch locationInView:[songTableList objectAtIndex:0]];
            NSIndexPath *indexPath = [[songTableList objectAtIndex:0] indexPathForRowAtPoint: currentTouchPosition];
            if (indexPath != nil){
                [self tableView: [songTableList objectAtIndex:0] accessoryButtonTappedForRowWithIndexPath: indexPath];
            }
        }
            break;
        case 1:{
            CGPoint currentTouchPosition = [touch locationInView:[songTableList objectAtIndex:1]];
            NSIndexPath *indexPath = [[songTableList objectAtIndex:1] indexPathForRowAtPoint: currentTouchPosition];
            if (indexPath != nil){
                [self tableView: [songTableList objectAtIndex:1] accessoryButtonTappedForRowWithIndexPath: indexPath];
            }
           
        }
            break;
        case 2:{
            CGPoint currentTouchPosition = [touch locationInView:[songTableList objectAtIndex:2]];
            NSIndexPath *indexPath = [[songTableList objectAtIndex:2] indexPathForRowAtPoint: currentTouchPosition];
            if (indexPath != nil){
                [self tableView: [songTableList objectAtIndex:2] accessoryButtonTappedForRowWithIndexPath: indexPath];
            }
        }
            break;
        case 3:{
            CGPoint currentTouchPosition = [touch locationInView:[songTableList objectAtIndex:3]];
            NSIndexPath *indexPath = [[songTableList objectAtIndex:3] indexPathForRowAtPoint: currentTouchPosition];
            if (indexPath != nil){
                [self tableView: [songTableList objectAtIndex:3] accessoryButtonTappedForRowWithIndexPath: indexPath];
            }
        }
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Reset Button
    if(tableView.tag == 0 && indexPath.section == 0){
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reset SetList", @"Reset Set List") message:NSLocalizedString(@"Do you want to reset setlist?", @"Do you want to reset setlist?") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"No") otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
        [alert show];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    }
}

//called when accessorybutton tapped
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    currentTag = tableView.tag;
    if(currentTag == 0){
        currentSection = indexPath.section - 1;
    } else{
        currentSection = indexPath.section;
    }
    currentRow = indexPath.row;
    [self performSegueWithIdentifier:@"itunesLink" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ( [[segue identifier] isEqualToString:@"itunesLink"] ) {
        SongDetailViewController *songDetailViewController = [segue destinationViewController];
        songDetailViewController.songName = [NSString stringWithString:[[[[songList objectAtIndex:currentTag] objectAtIndex:currentSection] objectAtIndex:currentRow] objectForKey:@"name"]];
        songDetailViewController.albumName = [NSString stringWithString:[[[[songList objectAtIndex:currentTag] objectAtIndex:currentSection] objectAtIndex:currentRow] objectForKey:@"album"]];
        songDetailViewController.albumPic = [NSString stringWithString:[[[[songList objectAtIndex:currentTag] objectAtIndex:currentSection] objectAtIndex:currentRow] objectForKey:@"album_pic"]];
        songDetailViewController.itunesLink = [NSString stringWithString:[[[[songList objectAtIndex:currentTag] objectAtIndex:currentSection] objectAtIndex:currentRow] objectForKey:@"itunes"]];
        
    
    }
}

//Called when song toggle is pushed
-(void)songTogglePushed:(NSNotification*) notification{
    
    NSDictionary *songDic = [[notification userInfo] objectForKey:@"Song"];
    PostInfoUtil *postInfo = [PostInfoUtil sharedCenter];
    NSUInteger index = [postInfo.songList indexOfObject:songDic];
    if(index != NSNotFound){
        [postInfo.songList removeObjectAtIndex:index];
    }else{
        [postInfo.songList addObject:songDic];

    }
}

#pragma mark -
#pragma mark UIAlertView Delegate Methods
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            {
                for(int i=0; i<[toggleControlList count]; i++){
                    for(int j=0; j<[[toggleControlList objectAtIndex:i] count]; j++){
                        for(int k=0; k<[[[toggleControlList objectAtIndex:i] objectAtIndex:j] count]; k++) {
                            
                            SongToggleControl *toggleControl = [[[toggleControlList objectAtIndex:i] objectAtIndex:j] objectAtIndex:k];
                            toggleControl.selected = 0;
                            toggleControl.imageView.image = toggleControl.normalImage;
                        }
                        
                    }
                }
                PostInfoUtil *postInfo = [PostInfoUtil sharedCenter];
                [postInfo.songList removeAllObjects];
    
            }
            break;
    }
    
}

#pragma mark -
#pragma mark AdBannerView Delegate Methods
-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, adBannerView.frame.size.height);
        [UIView commitAnimations];
        bannerIsVisible = YES;
        adBannerView.frame = CGRectMake(adBannerView.frame.origin.x, adBannerView.frame.origin.y, self.view.frame.size.width, adBannerView.frame.size.height);
        for(UITableView *songTable in songTableList){
            songTable.frame = CGRectMake(songTable.frame.origin.x, songTable.frame.origin.y + adBannerView.frame.size.height, songTable.frame.size.width, songTable.frame.size.height - adBannerView.frame.size.height);
        }
    }
}


-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -adBannerView.frame.size.height);
        [UIView commitAnimations];
        bannerIsVisible = NO;
        for(UITableView *songTable in songTableList){
            songTable.frame = CGRectMake(songTable.frame.origin.x, 0, songTable.frame.size.width,  self.view.frame.size.height);
        }
    }
}







@end
