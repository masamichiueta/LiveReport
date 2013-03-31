//
//  PostListViewController.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/28.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "PostListViewController.h"

#import "TweetData.h"
#import "TwitterTableViewCell.h"

#import "PrettyKit.h"
#import <QuartzCore/QuartzCore.h>

@interface PostListViewController ()

@end

@implementation PostListViewController
@synthesize postListTable=_postListTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)FromInterfaceOrientation {
    if(bannerIsVisible){
        adBannerView.frame = CGRectMake(adBannerView.frame.origin.x, adBannerView.frame.origin.y, self.view.frame.size.width, adBannerView.frame.size.height);
        _postListTable.frame = CGRectMake(_postListTable.frame.origin.x, _postListTable.frame.origin.y + adBannerView.frame.size.height, _postListTable.frame.size.width, _postListTable.frame.size.height - adBannerView.frame.size.height);
    }
    else{
        _postListTable.frame = CGRectMake(_postListTable.frame.origin.x, 0, _postListTable.frame.size.width, self.view.frame.size.height);
    }
    
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
    navBar.roundedCornerRadius = 10;
    
}

#pragma mark -
#pragma mark Initialization
- (void) initTableView{
    _postListTable.delegate = self;
    _postListTable.dataSource = self;
    _postListTable.scrollsToTop = YES;
    [_postListTable dropShadows];
    _postListTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (void) initEGORefreshTableHeaderView{
    if (refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _postListTable.bounds.size.height, _postListTable.frame.size.width, _postListTable.bounds.size.height)];
		view.delegate = self;
		[_postListTable addSubview:view];
		refreshHeaderView = view;
		
	}
	
	//  update the last update date
	[refreshHeaderView refreshLastUpdatedDate];
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
	// Do any additional setup after loading the view.
    [self customizeNavBar];
    [self initTableView];
    [self initEGORefreshTableHeaderView];
    [self initIAd];
    
    tweetList = [NSMutableArray array];
    imageStore = [[ImageStore alloc] initWithDelegate:self];
    
    [self getTweets];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([tweetList count] != 0){
        TweetData *tweet = [tweetList objectAtIndex:indexPath.row];
        TwitterTableViewCell *cellForHeight = [[TwitterTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cellForHeight setupRowData:tweet];
        
        CGSize size;
        size.width = _postListTable.frame.size.width;
        size.height = TweetMaxCellHeight;
        size = [cellForHeight sizeThatFits:size];
        
        if(size.height < TweetMinCellHeight){
            return TweetMinCellHeight;
        }
        else    return size.height;
    }
    else return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tweetList count] != 0){
        return [tweetList count];
    }
    else return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(section == ([_postListTable numberOfSections] -1)){
        //Localize
        NSString* tableFooter = NSLocalizedString(@"RockFordRecords Co., Ltd.", @"RockFordRecords Co., Ltd.");
        return tableFooter;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    TwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TwitterTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    cell.cornerRadius = 5;
    cell.customSeparatorColor = [UIColor colorWithHex:0xCC3599];
    cell.borderColor = [UIColor colorWithHex:0xCC3599];
    [cell prepareForTableView:tableView indexPath:indexPath];
    
    if([tweetList count] != 0){
        cell.textLabel.text = nil;
        [cell setupRowData:[tweetList objectAtIndex:indexPath.row]];
        
        UIImage *iconImage = [imageStore getImage:[[tweetList objectAtIndex:indexPath.row] iconImageURL]];
        
        
        if(iconImage != nil){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            cell.imageView.image = iconImage;
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = 5.0f;
        }
        else {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            cell.imageView.image = [UIImage imageNamed:@"nouser"];
        }
    }
    else{
        cell.textLabel.text = NSLocalizedString(@"No Result", @"No Result");
    }

    
    return cell;
    
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	reloading = YES;
    
    [self getTweets];
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_postListTable];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}



- (void)getTweets{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:TWITTER_SEARCH]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(!connection){
        NSLog(@"connectino error");
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate Method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"didReceiveResponse");
    
    tweetData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"didReceiveData");
    
    [tweetData appendData:data];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(reloading) [self doneLoadingTableViewData];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connectionDidFinishLoading");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [tweetList removeAllObjects];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:tweetData options:0 error:nil];
    
    for(int i=0; i<[[jsonDictionary objectForKey:@"results"] count]; i++){
        TweetData *rowData = [[TweetData alloc] init];
        rowData.userName = [[[jsonDictionary objectForKey:@"results"] objectAtIndex:i] objectForKey:@"from_user"];
        rowData.status = [[[jsonDictionary objectForKey:@"results"] objectAtIndex:i] objectForKey:@"text"];
        rowData.createdAt = [[[jsonDictionary objectForKey:@"results"] objectAtIndex:i] objectForKey:@"created_at"];
        rowData.iconImageURL = [[[jsonDictionary objectForKey:@"results"] objectAtIndex:i] objectForKey:@"profile_image_url"];
        [tweetList addObject:rowData];
    }
    [_postListTable reloadData];
    if(reloading) [self doneLoadingTableViewData];
}


#pragma mark -
#pragma mark - ImageStore Delegate Methods
- (void)imageStoreDidGetNewImage:(ImageStore*)sender url:(NSString*)url
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_postListTable reloadData];
    
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
        _postListTable.frame = CGRectMake(_postListTable.frame.origin.x, _postListTable.frame.origin.y + adBannerView.frame.size.height, _postListTable.frame.size.width, _postListTable.frame.size.height - adBannerView.frame.size.height);
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
        _postListTable.frame = CGRectMake(_postListTable.frame.origin.x, 0, _postListTable.frame.size.width, self.view.frame.size.height);
    }
}


@end
